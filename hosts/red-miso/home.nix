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
    sioyek
    sops
    anydesk
    mission-center
    mpv
    papers
    wl-clipboard-x11
    delta
    signal-desktop
    telegram-desktop
    claude-code
    codebook
    nixd
    xpipe
    zk
    alacritty
    ghostty
    zen-browser
    proton-authenticator
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

  # Default terminal (xdg-terminal-exec spec) -> COSMIC Terminal
  xdg.configFile."xdg-terminals.list".text = ''
    com.system76.CosmicTerm.desktop
  '';

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.system76.CosmicTerm.desktop";
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "text/calendar" = "thunderbird.desktop";
      "application/ics" = "thunderbird.desktop";
      "x-scheme-handler/webcal" = "thunderbird.desktop";
      "x-scheme-handler/webcals" = "thunderbird.desktop";
    };
  };
}
