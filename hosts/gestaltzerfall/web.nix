# Central File for all Web Services
{ config, pkgs, ... }:
{
  ## Traefik Config
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };
      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };
      certificatesResolvers.letsencrypt.acme = {
        email = "development@milanmueller.de";
        storage = "{config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };
      api.dashboard = true;
      api.insecure = true;
    };
    dynamicConfigOptions = {
      http.routers = { };
      http.services = { };
    };
  };
  ## ttyd (Terminal in Browser)
  services.ttyd = {
    enable = true;
    user = "milan";
    writeable = true;
  };
}
