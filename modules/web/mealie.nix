{
  config,
  webParams,
  ...
}:
{
  sops.secrets."mealie/oidc_client_secret" = { };
  sops.templates."mealie-env".content = ''
    OIDC_CLIENT_SECRET=${config.sops.placeholder."mealie/oidc_client_secret"}
  '';

  ## Mealie (recipe manager); state lives in /var/lib/mealie (persistent dataset)
  services.mealie = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = webParams.internalPorts.mealie;
    credentialsFile = config.sops.templates."mealie-env".path;
    settings = {
      BASE_URL = "https://nomnom.milanmueller.de";
      ALLOW_SIGNUP = "false";
      TZ = "Europe/Berlin";

      # Login via Authelia (OIDC)
      OIDC_AUTH_ENABLED = "true";
      OIDC_PROVIDER_NAME = "Authelia";
      OIDC_CONFIGURATION_URL = "https://auth.milanmueller.de/.well-known/openid-configuration";
      OIDC_CLIENT_ID = "mealie";
      OIDC_SIGNUP_ENABLED = "true";
      OIDC_ADMIN_GROUP = "admin";
      OIDC_AUTO_REDIRECT = "true";
    };
  };
}
