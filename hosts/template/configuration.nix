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
    ../../modules/defaults.nix
    ../../modules/autopull.nix
    ../../modules/sshd.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # DO NOT CHANGE For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
