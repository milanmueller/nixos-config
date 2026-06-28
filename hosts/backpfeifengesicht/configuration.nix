{
  config,
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/defaults.nix
    ../../modules/sshd.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

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

  # Nvidia GPU (GTX 1060 Ti / Pascal – closed-source driver required)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # required for Steam / Proton
  };

  # GNOME Desktop Environment
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Steam + gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # Bootloader
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

  # Key remapping (kernel-level, works on Wayland)
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "escape";
        escape = "grave";
      };
    };
  };

  # Services
  services.printing.enable = true;

  ## Virtualization
  virtualisation.podman = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # DO NOT CHANGE
  system.stateVersion = "25.05";
}
