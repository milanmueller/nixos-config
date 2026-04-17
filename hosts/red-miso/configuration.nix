# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  userConfig,
  # lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include global modules (shared between machines)
    ../../modules/defaults.nix
    ../../modules/sshd.nix
  ];

  # Create Sawpfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Logitech stuff
  hardware.logitech.wireless.enable = true;

  # FW-Update
  services.fwupd.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;

  # Video encoding
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # vaapiIntel
      vpl-gpu-rt
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # Default User
  users.users.${userConfig.username}.extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
    "libvirtd"
    "input"
  ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Pass COLORTERM variable in ssh sessions
  programs.ssh.extraConfig = ''
    Host *
      SendEnv COLORTERM
  '';

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    git
    podman-compose
    nil
    home-manager
  ];

  # System fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    ubuntu-classic
  ];

  # User Programs
  programs.firefox.enable = true;

  # Mouse side button remapping (G305: BTN_SIDE → Ctrl, BTN_EXTRA → Alt)
  services.evremap = {
    enable = true;
    settings = {
      device_name = "Logitech G305";
      remap = [
        { input = [ "BTN_SIDE" ]; output = [ "KEY_LEFTCTRL" ]; }
        { input = [ "BTN_EXTRA" ]; output = [ "KEY_LEFTALT" ]; }
      ];
    };
  };

  # Cosmic DE
  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };
  services.displayManager.cosmic-greeter.enable = true;

  # Services
  # Enable CUPS to print documents.
  services.printing.enable = true;

  ## Virtualization
  # Enable Podman
  virtualisation.podman = {
    enable = true;
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Enable libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05"; # Did you read the comment?
}
