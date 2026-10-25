# Nightly update of all oci-containers: pull newer images and recreate the containers
{
  config,
  lib,
  pkgs,
  ...
}:
let
  backend = config.virtualisation.oci-containers.backend;
  containerUnits = lib.mapAttrsToList (
    name: _: "${backend}-${name}.service"
  ) config.virtualisation.oci-containers.containers;
in
{
  # Pull on every container start if the registry has a newer image
  # (falls back to the local image if the registry is unreachable)
  options.virtualisation.oci-containers.containers = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config.pull = lib.mkDefault "newer";
      }
    );
  };

  config = {
    systemd.services.container-autoupdate = {
      description = "Pull newer container images and recreate all oci-containers";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        systemctl restart ${lib.concatStringsSep " " containerUnits}
        ${pkgs.${backend}}/bin/${backend} image prune --force
      '';
    };

    systemd.timers.container-autoupdate = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 02:00:00 Europe/Berlin";
        Persistent = true; # catch up on missed runs (e.g. host was off)
      };
    };
  };
}
