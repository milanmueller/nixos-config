{
  pkgs,
  lib,
  nix-colors,
  colorParams,
  ...
}:
let
  activeScheme =
    if colorParams.currentMode == "dark" then
      nix-colors.colorSchemes.${colorParams.darkModeScheme}
    else
      nix-colors.colorSchemes.${colorParams.lightModeScheme};
in
{
  imports = [
    ../../modules/home/defaults.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/zed.nix
    ../../modules/home/firefox.nix
    # Cosmic theme generation from base16 (shared with red-miso)
    ../red-miso/home/cosmic-config.nix
    ../red-miso/home/dark-light-toggle.nix
  ];

  colorScheme = lib.mkForce activeScheme;

  programs.ssh = {
    extraConfig = "
      SendEnv COLORTERM
    ";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.05";

  # Install Packages
  home.packages = with pkgs; [
    thunderbird
    sops
    mission-center
    wl-clipboard-x11
    claude-code
    codebook
    nixd
    zk
    google-chrome
    zen-browser
    proton-authenticator
  ];

  home.sessionVariables = {
    ISABELLE_HOME = "/home/milan/.isabelle";
  };

  programs.sioyek.bindings = {
    "next_page" = "J";
    "previous_page" = "K";
  };

  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "text/calendar" = "thunderbird.desktop";
      "application/ics" = "thunderbird.desktop";
      "x-scheme-handler/webcal" = "thunderbird.desktop";
      "x-scheme-handler/webcals" = "thunderbird.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
    };
  };

}
