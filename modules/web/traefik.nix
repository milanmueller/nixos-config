{
  config,
  pkgs,
  webdata,
  internalPorts,
  webParams,
  ...
}:
{
  # Traefik Config
  services.traefik = {
    enable = true;
    dataDir = "${webParams.webdata}/traefik";
    staticConfigOptions = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };
      entryPoints = {
        web = {
          address = ":80";
        };
        websecure = {
          address = ":443";
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
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };
      api = {
        dashboard = true;
        # insecure = true;
      };
    };
    dynamicConfigOptions = {
      http = {
        routers = {
          ttyd = {
            rule = "Host(`gestaltzerfall.milanmueller.de`)";
            service = "ttyd";
            entryPoints = [ "websecure" ];
            tls.certResolver = "letsencrypt";
            middlewares = [ "authelia" ];
          };
          authelia = {
            rule = "Host(`auth.milanmueller.de`)";
            service = "authelia";
            entryPoints = [ "websecure" ];
            tls.certResolver = "letsencrypt";
          };
          dashboard = {
            rule = "Host(`traefik.milanmueller.de`)";
            service = "api@internal";
            entryPoints = [ "websecure" ];
            tls.certResolver = "letsencrypt";
            middlewares = [ "authelia" ]; # Protect dashboard
          };
        };
        services = {
          ttyd = {
            loadBalancer.servers = [ { url = "http://localhost:${toString webParams.internalPorts.ttyd}"; } ];
          };
          authelia = {
            loadBalancer.servers = [
              { url = "http://localhost:${toString webParams.internalPorts.authelia}"; }
            ];
          };
        };
        middlewares = {
          authelia = {
            forwardAuth = {
              address = "http://localhost:${toString webParams.internalPorts.authelia}/api/verify?rd=https://auth.milanmueller.de";
              trustForwardHeader = true;
              authResponseHeaders = [
                "Remote-User"
                "Remote-Groups"
                "Remote-Name"
                "Remote-Email"
              ];
            };
          };
        };
      };
    };
  };
}
