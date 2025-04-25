{
  config,
  pkgs,
  ...
}:
let
in
{
  imports = [
    ./traefik.nix
    ./authelia.nix
    ./ttyd.nix
    ./crowdsec.nix
  ];

  # Open required firewall ports (include ssh here!)
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
