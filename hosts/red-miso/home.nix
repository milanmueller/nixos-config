{
  lib,
  pkgs,
  ...
}:
let
  helixLanguages = map (
    option:
    option
    // {
      language-servers = option.language-servers ++ [ "gpt" ];
    }
  ) (import ../../modules/home/helix-languages.nix { inherit lib pkgs; }).languages;
in
{
  imports = [
    ../../modules/home/defaults.nix
    # ../../lib/cosmic-config.nix
  ];

  # Cosmic Testing
  # programs.cosmic-themes-base16 = {
  #   enable = true;
  #   theme = {
  #     mode = "dark"; # or "light"
  #     base00 = "#181818"; # Background
  #     base01 = "#282828"; # Lighter background
  #     base02 = "#383838"; # Selection background
  #     base03 = "#585858"; # Comments, invisibles
  #     base04 = "#b8b8b8"; # Dark foreground
  #     base05 = "#d8d8d8"; # Default foreground
  #     base06 = "#e8e8e8"; # Light foreground
  #     base07 = "#f8f8f8"; # Light background
  #     base08 = "#ab4642"; # Red
  #     base09 = "#dc9656"; # Orange
  #     base0A = "#f7ca88"; # Yellow
  #     base0B = "#a1b56c"; # Green
  #     base0C = "#86c1b9"; # Cyan
  #     base0D = "#7cafc2"; # Blue
  #     base0E = "#ba8baf"; # Purple
  #     base0F = "#a16946"; # Brown
  #   };
  # };

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
    helix-gpt
    sops
    anydesk
    claude-code
    aider-chat
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
  programs.helix.languages = {
    language-server.gpt = (import ./home/helix-gpt-wrapper.nix { inherit pkgs; }).helix_lsp;
    language = helixLanguages;
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
