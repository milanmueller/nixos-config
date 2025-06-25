{
  lib,
  pkgs,
  ...
}:
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
    zola
    gnome-boxes
    mission-center
    mpv
    papers
    blanket
    gnome-solanum
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

  # Configure helix-gpt using copilot api key from sops secrets (set in configuration.nix)
  # programs.helix.languages = {
  #   language-server.gpt = (import ./home/helix-gpt-wrapper.nix { inherit pkgs; }).helix_lsp;
  #   language = helixLanguages;
  # };

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
    };
  };
}
