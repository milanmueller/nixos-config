{
  config,
  pkgs,
  lib,
  webParams,
  ...
}:
{
  ## ttyd (Terminal in Browser)
  services.ttyd = {
    enable = true;
    port = webParams.internalPorts.ttyd;
    interface = "0.0.0.0";
    writeable = true;
    enableIPv6 = true;
  };
}
