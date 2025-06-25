{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  imports = [
    ./i18n.nix
    # ./zerotier.nix
    ./network/wireguard.nix
    ./home-manager.nix
    ./nix-settings.nix
    # ./sshd.nix
  ];
  # Networking
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  #
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = "Milan Müller";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7kzswyDXmBSUT/jwDXXGT+ZWnouuqvauXDIxQxcRhT development@milanmueller.de"
    ];
    shell = pkgs.nushell;
  };
}
