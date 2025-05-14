{ pkgs, lib, ... }:
{
  services.crowdsec = {
    enable = true;
    settings = {
      api_key = "asdf";
    };
  };
}
