# Central File for all Web Services
{
  config,
  pkgs,
  lib,
  webParams,
  ...
}:
let
  autheliaSysUser = "authelia";
in
{
  # Sops secrets
  sops.secrets."authelia/jwt_secret" = {
    owner = autheliaSysUser;
    mode = "0400";
  };
  sops.secrets."authelia/storage_secret" = {
    owner = autheliaSysUser;
    mode = "0400";
  };
  sops.secrets."authelia/admin_pw" = { };
  sops.secrets."authelia/milan_pw" = { };
  sops.secrets."authelia/smtp/address" = { };
  sops.secrets."authelia/smtp/username" = { };
  sops.secrets."authelia/smtp/password" = { };
  sops.secrets."authelia/duo/api_hostname" = { };
  sops.secrets."authelia/duo/integration_key" = { };
  sops.secrets."authelia/duo/secret_key" = { };
  users.groups.${webParams.webdataSysGroup} = { };
  users.users.${autheliaSysUser} = {
    isSystemUser = true;
    group = webParams.webdataSysGroup;
  };
  # Authelia Container
  virtualisation.oci-containers.containers."authelia" = {
    image = "authelia/authelia:latest";
    # user = "${autheliaSysUser}:${webdataSysGroup}";
    ports = [
      "${toString webParams.internalPorts.authelia}:${toString webParams.internalPorts.authelia}"
    ];
    volumes = [
      "${webParams.webdata}/authelia/data:/data"
      "/etc/authelia/:/config"
      "${config.sops.secrets."authelia/jwt_secret".path}:/secrets/JWT_SECRET:ro"
      "${config.sops.secrets."authelia/storage_secret".path}:/secrets/STORAGE_SECRET:ro"
    ];
    environment = {
      "AUTHELIA_IDENTITY_VALIDATION_RESET_PASSWORD_JWT_SECRET_FILE" = "/secrets/JWT_SECRET";
      "AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE" = "/secrets/STORAGE_SECRET";
    };
  };

  ### Write Authelia admin pw to config file from secrets
  systemd.services.authelia-users-db-setup = {
    description = "Generate Authelia users_database.yml from SOPS secret";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix-secrets.service" ]; # Ensure SOPS secrets are available
    before = [ "podman-authelia.service" ]; # Run before Authelia container
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          script = pkgs.writeText "generate-users-db.sh" ''
            #!/bin/bash
            set -e
            ADMIN_PASSWORD=$(cat ${config.sops.secrets."authelia/admin_pw".path})
            MILAN_PASSWORD=$(cat ${config.sops.secrets."authelia/milan_pw".path})
            cat <<EOF > /etc/authelia/users_database.yml
            users:
              admin:
                displayname: "Admin User"
                password: "$ADMIN_PASSWORD"
                email: "mail@milanmueller.de"
                groups:
                  - admin
              milan:
                displayname: "Milan Müller"
                password: "$MILAN_PASSWORD"
                email: "mail@milanmueller.de"
                groups: []
            EOF
            chmod 0400 /etc/authelia/users_database.yml
            chown ${autheliaSysUser}:${webParams.webdataSysGroup} /etc/authelia/users_database.yml
          '';
        in
        "${pkgs.bash}/bin/bash ${script}";
    };
  };

  # Write authelia config to disk including secrets
  systemd.services.authelia-config = {
    description = "Generate Authelia configuration.yml from SOPS secret";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix-secrets.service" ]; # Ensure SOPS secrets are available
    before = [ "podman-authelia.service" ]; # Run before Authelia container
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          script = pkgs.writeText "generate-users.sh" ''
            #!/bin/bash
            set -e
            SMTP_SERVER=$(cat ${config.sops.secrets."authelia/smtp/address".path})
            SMTP_USER=$(cat ${config.sops.secrets."authelia/smtp/username".path})
            SMTP_PASSWORD=$(cat ${config.sops.secrets."authelia/smtp/password".path})
            DUO_HOSTNAME=$(cat ${config.sops.secrets."authelia/duo/api_hostname".path})
            DUO_INTEGRATION_KEY=$(cat ${config.sops.secrets."authelia/duo/integration_key".path})
            DUO_SECRET_KEY=$(cat ${config.sops.secrets."authelia/duo/secret_key".path})
            cat <<EOF > /etc/authelia/configuration.yml
            server:
              address:
                'tcp://:${toString webParams.internalPorts.authelia}'
            log:
              level: 'debug'
            authentication_backend:
              file:
                path: '/config/users_database.yml'
            access_control:
              default_policy: 'two_factor'
            storage:
              local:
                path: '/data/db.sqlite3'
            notifier:
              smtp:
                address: 'submissions://$SMTP_SERVER:465'
                username: '$SMTP_USER'
                password: '$SMTP_PASSWORD'
                sender: 'Authelia <mail@milanmueller.de>'
                subject: '[Authelia] {title}'
            session:
              cookies:
                - name: 'authelia_session'
                  domain: 'milanmueller.de'
                  authelia_url: 'https://auth.milanmueller.de'
                  expiration: '1 hour'
                  inactivity: '5 minutes'
            duo_api:
              disable: false
              hostname: '$DUO_HOSTNAME'
              integration_key: '$DUO_INTEGRATION_KEY'
              secret_key: '$DUO_SECRET_KEY'
              enable_self_enrollment: false                  
            EOF
            chmod 0400 /etc/authelia/configuration.yml
            chown ${autheliaSysUser}:${webParams.webdataSysGroup} /etc/authelia/configuration.yml
          '';
        in
        "${pkgs.bash}/bin/bash ${script}";
    };
  };
}
