{
  config,
  pkgs,
  inputs,
  nix-colors,
  ...
}:
{
  imports = [
    ../../modules/home/helix.nix
    ../../modules/home/nushell.nix
    ../../modules/home/git.nix
    # ../../lib/cosmic-config.nix
  ];

  ## Custom Cosmic Module (Just for testing for now)
  # cosmicTerm = {
  #   enable = true;
  #   fontSize = 16;
  # };

  # Basics
  home.username = "milan";
  home.homeDirectory = "/home/milan";

  # direnv #TODO: move out of here
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself
  programs.home-manager.enable = true;

  # Install Packages
  home.packages = with pkgs; [
    thunderbird
    distrobox
    zoom-us
    ranger
    sioyek
    helix-gpt
  ];

  # Install and configure programs
  programs = {
    sioyek = {
      enable = true;
      config = {
        "should_launch_new_window" = "1";
      };
    };
  };

  # Install and configure services
  services = {
    nextcloud-client = {
      enable = true;
      startInBackground = true;
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

  # Flatpaks
  # services.flatpak.packages = [
  #   "com.logseq.Logseq"
  #   "net.nokyan.Resources"
  #   "page.codeberg.libre_menu_editor.LibreMenuEditor"
  #   "org.gnome.Fractal"
  #   "org.gnome.Papers"
  #   "com.anydesk.Anydesk"
  #   "org.keepassxc.KeePassXC"
  #   "org.gnome.gitlab.somas.Apostrophe"
  #   "org.gnome.gitlab.somas.Apostrophe.Plugin.TexLive"
  # ];

}
