{ config, pkgs, ... }:
{
  systemd.services.update-nixos-config = {
    description = "Pull NixOS configuration from Git repository";
    serviceConfig = {
      Type = "oneshot";
      User = "milan";  
      WorkingDirectory = "/home/milan/nixos-config";
      ExecStart = "${pkgs.git}/bin/git pull";
    };
  };

  systemd.timers.update-nixos-config = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistend = true;
    };
  };
}
