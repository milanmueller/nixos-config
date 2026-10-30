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
    ../../modules/sshd.nix
    ../../modules/container-autoupdate.nix
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
  # networking.interfaces.ensp1s0.useDHCP = true;

  # Hetzner Cloud only provides IPv4 via DHCP, IPv6 has to be configured statically
  networking.networkmanager.ensureProfiles.profiles.enp1s0 = {
    connection = {
      id = "enp1s0";
      type = "ethernet";
      interface-name = "enp1s0";
    };
    ipv4.method = "auto";
    ipv6 = {
      method = "manual";
      address1 = "2a01:4f8:c012:d3ef::1/64";
      gateway = "fe80::1";
    };
  };

  # Configuration of sshd (enable remote connections)
  services.openssh.settings.PasswordAuthentication = lib.mkForce false;

  # Enable fail2ban since cafo is publicly reachable
  services.fail2ban.enable = true;

  # Swap in compressed RAM (swapfiles are not supported on ZFS), capped at 4G
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 4 * 1024 * 1024 * 1024;
  };

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
  # postDeviceCommands is only supported by the scripted stage 1, and
  # nixpkgs now defaults to the systemd one. Keep scripted until this is
  # ported to boot.initrd.systemd.services.
  boot.initrd.systemd.enable = false;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zpool01/nixos/empty@start
  '';

  # DO NOT CHANGE For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
