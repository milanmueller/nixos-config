{ config, pkgs, lib, ... }:

let
  # Fetch firefox-gnome-theme from GitHub
  firefox-gnome-theme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v143";
    sha256 = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
  };
in
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # Required for userChrome.css theming
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;

        # Use system GTK theme (libadwaita)
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "browser.theme.toolbar-theme" = 2; # 0=light, 1=dark, 2=system
        "browser.theme.content-theme" = 2; # 0=light, 1=dark, 2=system

        # Enable session restore
        "browser.sessionstore.resume_from_crash" = true;
        "browser.startup.page" = 3; # Restore previous session on startup

        # GNOME theme recommended settings
        "browser.uidensity" = 0; # Normal density
        "browser.tabs.inTitlebar" = 1;
      };

      # Import firefox-gnome-theme userChrome
      userChrome = ''
        @import "${firefox-gnome-theme}/userChrome.css";
      '';

      # Import firefox-gnome-theme userContent
      userContent = ''
        @import "${firefox-gnome-theme}/userContent.css";
      '';
    };
  };
}
