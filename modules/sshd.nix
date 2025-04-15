{ config, pkgs, ... }:
{
  # Configuration of sshd (enable remote connections)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "milan" ];
      UseDns = true;
      PermitRootLogin = "no";
      AcceptEnv = "LANG LC_* COLORTERM";
    };
  };
}
