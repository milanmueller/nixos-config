{
  config,
  pkgs,
  lib,
  ...
}:
let
  params = import ./parameters.nix;
in
{
  ## ttyd (Terminal in Browser)
  services.ttyd = {
    enable = true;
    port = params.internalPorts.ttyd;
    interface = "0.0.0.0";
    writeable = true;
    enableIPv6 = true;
  };
}
