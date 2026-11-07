{
  pkgs,
  lib,
  mkScheme,
  colorParams,
  osConfig,
  ...
}:
let
  activeScheme =
    if osConfig.theme.mode == "dark" then
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
    # Autologin never unlocks the keyring, so keep Chrome from asking for it
    # Black video on Netflix with the proprietary Nvidia driver (Pascal) on Wayland:
    # disable GPU video decode so frames are rendered via the software path,
    # and run via XWayland instead of native Wayland
    (google-chrome.override {
      commandLineArgs = lib.concatStringsSep " " [
        "--password-store=basic"
        "--ozone-platform=x11"
      ];
    })
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

  # Default terminal (xdg-terminal-exec spec) -> Ghostty
  xdg.configFile."xdg-terminals.list".text = ''
    com.mitchellh.ghostty.desktop
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
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
