{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
    # ../../lib/cosmic-config.nix
  ];

  ## Custom Cosmic Module (Just for testing for now)
  # cosmicTerm = {
  #   enable = true;
  #   fontSize = 16;
  # };

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
}
