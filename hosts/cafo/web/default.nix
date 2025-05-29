{
  config,
  pkgs,
  ...
}:
let
in
{
  imports = [
    ../../../modules/web/traefik.nix
    ../../../modules/web/authelia.nix
    ../../../modules/web/ttyd.nix
    # ../../../modules/web/crowdsec.nix
  ];

  # Open required firewall ports (include ssh here!)
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
