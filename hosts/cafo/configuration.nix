# Edit this configuration file to define what should be installed on your system. Help is available in the
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ../../modules/defaults.nix
    ../../modules/autopull.nix
    ./web
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.generic-extlinux-compatible.enable = true;

  # Enable ZFS for bootloader
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "8425e349"; # required for zfs

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
    oci-containers.backend = "podman";
  };
  # Allow default user to access podman
  users.groups.podman.members = [ userConfig.username ];

  # Rollback to initial root snapshot, based on https://grahamc.com/blog/erase-your-darlings/
  # and https://notthebe.ee/blog/nixos-ephemeral-zfs-root/ (ephemeral root)
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zpool01/nixos/empty@start
  '';

  # DO NOT CHANGE For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
