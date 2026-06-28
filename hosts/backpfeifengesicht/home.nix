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
    anydesk
    mission-center
    mpv
    papers
    wl-clipboard-x11
    zoom-us
    delta
    signal-desktop
    telegram-desktop
    claude-code
    codex
    mistral-vibe
    codebook
    nixd
    xpipe
    zk
    fractal
    element-desktop
    alacritty
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
}
