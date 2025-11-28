{
  lib,
  pkgs,
  ...
}:
let
  proton-authenticator = pkgs.callPackage ../../overlays/proton-authenticator.nix { };
in
{
  imports = [
    ../../modules/home/defaults.nix
    ./home/cosmic-config.nix
    ./home/dark-light-toggle.nix
  ];

  # direnv #TODO: move out of here
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.05";

  # Install Packages
  home.packages = with pkgs; [
    thunderbird
    distrobox
    sioyek
    anytype
    sops
    anydesk
    mission-center
    mpv
    papers
    gemini-cli
    lsp-ai
    ollama
    proton-authenticator
    wl-clipboard-x11
    zoom-us
    delta
  ];

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
