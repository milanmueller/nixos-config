{
  pkgs,
  config,
  lib,
  mkScheme,
  colorParams,
  osConfig,
  ...
}:
let
  # Active mode comes from the NixOS specialisation (modules/theme-mode.nix)
  currentMode = osConfig.theme.mode;

  # Get the active color scheme based on current mode
  activeScheme =
    if currentMode == "dark" then
      mkScheme colorParams.darkModeScheme
    else
      mkScheme colorParams.lightModeScheme;

in
{
  imports = [
    ../../modules/home/defaults.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/zed.nix
    ../../modules/home/firefox.nix
    ../../modules/home/zen.nix
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
    claude-code
    codebook
    nixd
    zen-browser
    proton-authenticator
  ];

  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
    };
    bindings = {
      "next_page" = "J";
      "previous_page" = "K";
    };
  };

  # Default terminal (xdg-terminal-exec spec) -> Ghostty
  xdg.configFile."xdg-terminals.list".text = ''
    com.mitchellh.ghostty.desktop
  '';

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
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
