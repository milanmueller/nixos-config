# Edit this configuration file to define what should be installed on your system. Help is available in the
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/autopull.nix
    ../../modules/i18n.nix
    ../../modules/zerotier.nix
    ../../modules/nix-settings.nix
    ../../modules/network/wireguard.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  networking.hostName = "gestaltzerfall"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostId = "2cf18810";

  # Allow unfree packages (required for zerotier)
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.milan = {
    isNormalUser = true;
    description = "Milan Müller";
    extraGroups = [
      "wheel"
      "podman"
    ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7kzswyDXmBSUT/jwDXXGT+ZWnouuqvauXDIxQxcRhT development@milanmueller.de"
    ];
    shell = pkgs.nushell;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable Flakes globally
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Home Manager Settings
  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Configuration of sshd (enable remote connections)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "milan" ];
      UseDns = true;
      PermitRootLogin = "no";
      AcceptEnv = "LANG LC_* COLORTERM";
    };
  };
  # Enable fail2ban for gestaltzerfall, since it is publicly reachable
  services.fail2ban.enable = true;

  # Enable Podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # DO NOT CHANGE For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
