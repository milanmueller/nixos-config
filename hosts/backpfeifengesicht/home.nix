{
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/home/defaults.nix
    ../../modules/home/zed.nix
    ../../modules/home/firefox.nix
  ];

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
    distrobox
    sioyek
    sops
    mission-center
    mpv
    papers
    wl-clipboard-x11
    zoom-us
    delta
    claude-code
    codex
    mistral-vibe
    codebook
    nixd
    xpipe
    zk
    ghostty
    gnomeExtensions.tiling-shell
    google-chrome
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
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Ubuntu 11";
      document-font-name = "Ubuntu 11";
      monospace-font-name = "JetBrainsMono Nerd Font 12";
      # True light mode: light top bar + white window decorations
      color-scheme = "prefer-light";
      gtk-theme = "Adwaita";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Bold 11";
    };
    # Clear Super+number from app-switching (dock) so it can be used for workspaces
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };
    # Super+number → switch to workspace N, Super+Shift+Q → close window
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super><Shift>q" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
    };
    # Super+Return → launch terminal
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/shell" = {
      enabled-extensions = [ "tilingshell@ferrarodomenico.com" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Terminal";
      command = "ghostty";
      binding = "<Super>Return";
    };
  };
}
