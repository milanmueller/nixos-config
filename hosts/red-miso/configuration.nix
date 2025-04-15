# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  nix-colors,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include global modules (shared between machines)
    ../../modules/defaults.nix
  ];

  # Networking
  networking.hostName = "red-miso";
  networking.networkmanager.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Video encoding
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # Default User
  users.users.milan = {
    isNormalUser = true;
    description = "Milan Müller";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.nushell;
  };

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
  ];

  # System fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # User Programs
  programs.firefox.enable = true;

  # Cosmic DE
  services.desktopManager.cosmic.enable = true;
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

  # DO NOT CHANGE
  system.stateVersion = "24.05"; # Did you read the comment?
}
