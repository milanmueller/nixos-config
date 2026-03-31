{
  pkgs,
  config,
  lib,
  nix-colors,
  colorParams,
  ...
}:
let
  # Get current mode from colorParams (flake-accessible)
  currentMode = colorParams.currentMode;

  # Get the active color scheme based on current mode
  activeScheme =
    if currentMode == "dark" then
      nix-colors.colorSchemes.${colorParams.darkModeScheme}
    else
      nix-colors.colorSchemes.${colorParams.lightModeScheme};

in
{
  imports = [
    ../../modules/home/defaults.nix
    ../../modules/home/zed.nix
    ../../modules/home/firefox.nix
    ./home/dark-light-toggle.nix
    ./home/cosmic-config.nix
  ];

  # Override the default colorScheme with our dynamic one
  colorScheme = lib.mkForce activeScheme;

  programs.ssh = {
    extraConfig = "
      SendEnv COLORTERM
    ";
  };

  # direnv #TODO: move out of here
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.05";

  # Install Packages
  home.packages = with pkgs; [
    thunderbird
    distrobox
    sioyek
    sops
    anydesk
    mission-center
    mpv
    papers
    wl-clipboard-x11
    zoom-us
    delta
    remmina
    signal-desktop
    telegram-desktop
    claude-code
    codebook
    nixd
    xpipe
  ];

  # Set environnment variables
  home.sessionVariables = {
    ISABELLE_HOME = "/home/milan/.isabelle";
  };

  # Additional syiokey keybindings
  programs.sioyek.bindings = {
    "next_page" = "J";
    "previous_page" = "K";
  };

  # Install and configure programs
  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
    };
  };

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
    };
  };
}
