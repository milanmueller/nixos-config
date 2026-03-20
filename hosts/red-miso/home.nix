{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/defaults.nix
    ./home/dark-light-toggle.nix
    ./home/cosmic-config.nix
  ];

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
    zed-editor
    claude-code
    nixd
  ];

  # Configure zed editor
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "helix_mode"
      "codebook"
    ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };
      helix_mode = true;
      terminal = {
        font_family = "JetBrainsMono Nerd Font Mono";
        shell = "system";
      };
      relative_line_numbers = true;
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
    };
  };

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
