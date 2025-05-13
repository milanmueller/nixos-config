{ config, lib, ... }:
let
  # Import host information
  hosts = import ./hosts.nix;

  # Get the current host's name
  hostName = config.networking.hostName;

  # Get the current host's configuration
  currentHost = hosts.${hostName};

  # Common WireGuard settings
  subnet = "10.0.0.0/24";

  # Helper to generate peer configurations
  mkPeer = host: {
    publicKey = host.publicKey;
    presharedKeyFile = config.sops.secrets."wireguard/psk".path;
    allowedIPs = [ "${host.wireguardIp}/32" ];
  };
  mkCentralPeer = host: {
    publicKey = host.publicKey;
    presharedKeyFile = config.sops.secrets."wireguard/psk".path;
    allowedIPs = [ subnet ];
    endpoint = host.endpoint;
    persistentKeepalive = 25;
  };

  # Central node peer list (all other hosts)
  centralPeers = lib.filterAttrs (name: host: name != hostName && !host.isCentral) hosts;

  # Client peer configuration (only the central node)
  centralNodes = lib.filterAttrs (name: host: name != hostName && host.isCentral) hosts;
in
{
  # SOPS secrets
  sops.secrets."wireguard/${hostName}/private_key" = { };
  sops.secrets."wireguard/psk" = { };

  # WireGuard configuration
  networking.wg-quick.interfaces.wg0 = {
    address = [ "${currentHost.wireguardIp}/24" ];
    # Suggested by LLM to fix ssh authentication issues
    mtu = 1280;
    privateKeyFile = config.sops.secrets."wireguard/${hostName}/private_key".path;
    # Set listenPort for contral nodes only
    listenPort = lib.mkIf currentHost.isCentral currentHost.listenPort;

    peers =
      if currentHost.isCentral then
        # Central node: peers are all clients
        map mkPeer (lib.attrValues centralPeers)
      else
        map mkCentralPeer (lib.attrValues centralNodes);
    # Client: peer is the central node
    # [
    #   {
    #     publicKey = centralNode.publicKey;
    #     presharedKeyFile = config.sops.secrets."wireguard/psk".path;
    #     allowedIPs = [ subnet ];
    #     endpoint = centralNode.endpoint;
    #     persistentKeepalive = 25;
    #   }
    # ];
  };

  # Central node specific settings
  networking.firewall.allowedUDPPorts = lib.optionals currentHost.isCentral [
    currentHost.listenPort
  ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkIf currentHost.isCentral 1;
}
