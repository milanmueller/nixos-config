{
  config,
  lib,
  pkgs,
  userConfig,
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
  ];
  # systemd.user.services.helix-gpt = {
  #   enable = true;
  #   after = [ "network.target" ];
  #   wantedBy = [ "default.target" ];
  #   description = "Set Copilot API Key as Environment Variable";

  # };

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
  # Write copilot key to environment variable from secret
  # systemd.user.services.sops-copilot-env = {
  #   Unit = {
  #     Description = "Set COPILOT_API_KEY from SOPS secret";
  #   };
  #   Install = {
  #     After = [ "network.target" ];
  #     WantedBy = [ "default.target" ];
  #   };
  #   Service = {
  #     ExecStart = ''
  #       ${pkgs.bash}/bin/bash -c \
  #       key=$(${pkgs.coreutils}/bin/cat /run/secrets/helix_gpt_copilot_key) \
  #       systemctl --user set-environment COPILOT_API_KEY="$key"
  #     '';
  #   };
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
