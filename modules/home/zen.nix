{
  mkScheme,
  colorParams,
  ...
}:
let
  # Zen's profile directory is created by Zen itself: it is the one marked
  # Default=1 in ~/.config/zen/profiles.ini (about:profiles shows it too).
  profileDir = ".config/zen/c7hh8jlm.Default Profile";

  lightScheme = mkScheme colorParams.lightModeScheme;
  darkScheme = mkScheme colorParams.darkModeScheme;

  # CSS custom properties for one scheme. Zen's own variables
  # (--zen-colors-*) plus the Firefox ones that Zen's chrome still reads.
  vars =
    scheme:
    let
      p = scheme.palette;
    in
    ''
      --zen-colors-primary: #${p.base0D} !important;
      --zen-colors-secondary: #${p.base01} !important;
      --zen-colors-tertiary: #${p.base00} !important;
      --zen-colors-border: #${p.base02} !important;
      --zen-colors-hover: #${p.base02} !important;
      --zen-primary-color: #${p.base0D} !important;
      --zen-main-browser-background: #${p.base00} !important;

      --toolbar-bgcolor: #${p.base01} !important;
      --toolbar-color: #${p.base05} !important;
      --toolbar-field-background-color: #${p.base00} !important;
      --toolbar-field-color: #${p.base05} !important;
      --toolbar-field-focus-background-color: #${p.base00} !important;
      --toolbar-field-focus-color: #${p.base05} !important;
      --toolbar-field-border-color: #${p.base02} !important;
      --toolbarbutton-icon-fill: #${p.base05} !important;
      --lwt-text-color: #${p.base05} !important;
      --lwt-accent-color: #${p.base00} !important;
      --tab-selected-bgcolor: #${p.base02} !important;
      --tab-selected-textcolor: #${p.base05} !important;
      --arrowpanel-background: #${p.base00} !important;
      --arrowpanel-color: #${p.base05} !important;
      --arrowpanel-border-color: #${p.base02} !important;
      --focus-outline-color: #${p.base0D} !important;
      --newtab-background-color: #${p.base00} !important;
      --newtab-background-color-secondary: #${p.base01} !important;
      --newtab-text-primary-color: #${p.base05} !important;
      --in-content-page-background: #${p.base00} !important;
      --in-content-page-color: #${p.base05} !important;
      --in-content-box-background: #${p.base01} !important;
      --in-content-border-color: #${p.base02} !important;
      --in-content-primary-button-background: #${p.base0D} !important;
      --link-color: #${p.base0D} !important;
    '';

  # Both palettes are always present; prefers-color-scheme follows the system
  # appearance, so toggling light/dark (tt) restyles open windows live,
  # without restarting Zen.
  css = ''
    :root {
      ${vars lightScheme}
    }
    @media (prefers-color-scheme: dark) {
      :root {
        ${vars darkScheme}
      }
    }
  '';
in
{
  home.file = {
    "${profileDir}/chrome/userChrome.css".text = css;
    # about:* pages (newtab, preferences, ...)
    "${profileDir}/chrome/userContent.css".text = ''
      @-moz-document url-prefix("about:") {
        ${css}
        body, html { background-color: var(--in-content-page-background) !important; color: var(--in-content-page-color) !important; }
      }
    '';
    # Required for userChrome.css / userContent.css to load
    "${profileDir}/user.js".text = ''
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    '';
  };
}
