{ config, pkgs, ... }:
{
  # Load Sops secret
  sops.secrets."zerotier_network_id" = { };
  # Enable zerotier
  services.zerotierone = {
    enable = true;
  };
  # Run zerotier with network id from secrets
  systemd.services.zerotierone-join = {
    description = "Join ZeroTier network with secret";
    wants = [ "network.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.zerotierone}/bin/zerotier-cli join $(cat ${config.sops.secrets.zerotier_network_id.path})"
      '';
      User = "root";
      RemainAfterExit = true;
    };
  };
}
