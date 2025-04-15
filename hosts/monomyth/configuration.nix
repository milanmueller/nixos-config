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
    ../../modules/sshd.nix
    ../../modules/zerotier.nix
    ../../modules/nix-settings.nix
    ../../modules/network/wireguard.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "monomyth"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Allow unfree packages (required for zerotier)
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.milan = {
    isNormalUser = true;
    description = "Milan Müller";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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

  # Enable ZFS for mirroring hdds
  # Taken from https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "7873d4a5";
  # Configure zfs to auto repair incositencies
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";
  # Configure zfs pool
  boot.zfs.extraPools = [ "hdds" ];

  # DO NOT CHANGE For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
