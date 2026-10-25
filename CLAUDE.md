# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a multi-host NixOS configuration managed with Nix Flakes. It configures four systems (x86_64 and aarch64) with shared modules and centralized secrets management via SOPS. Hosts are connected via Tailscale.

**Key architectural pattern:** The `flake.nix` defines a `mkHost` function that templates NixOS system configurations. Each host imports shared modules from `modules/` and can selectively override or extend with host-specific configurations.

## Common Commands

### Basic NixOS Operations

```bash
# Build and activate configuration on current host
sudo nixos-rebuild switch

# Test configuration without activating (temporary until reboot)
sudo nixos-rebuild test

# Build configuration for next boot without activating now
sudo nixos-rebuild boot

# Update all flake inputs
nix flake update

# Update specific input (e.g., nixpkgs, secrets)
nix flake update <input-name>
```

### Development Environment

```bash
# Enable development shell (includes claude-code)
nix develop

# Or with direnv (if .envrc exists)
direnv allow
```

### Building Specific Hosts

```bash
# Build configuration for specific host
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Cross-compile for aarch64 from x86_64
nix build --system aarch64-linux .#nixosConfigurations.cafo.config.system.build.toplevel
```

## Architecture

### Flake Structure

**Inputs:**
- `nixpkgs` (nixos-unstable) - Main package repository
- `home-manager` - User environment management
- `sops-nix` - Secrets encryption/management
- `secrets` (private SSH repo) - SOPS-encrypted secrets
- `nix-colors` - Color scheme management (default: Catppuccin Latte)
- `crowdsec` - DDoS/bot protection (gestaltzerfall, cafo only)
- `flatpaks` - Flatpak integration (red-miso only)

**Outputs:**
- `nixosConfigurations.<hostname>` - System configurations for each host
- `devShells.<system>.default` - Development environment with claude-code

### Module Composition Pattern

Every host follows this import chain:

**System Level** (`hosts/<hostname>/configuration.nix`):
```
configuration.nix
├── hardware-configuration.nix (generated)
├── modules/defaults.nix (all hosts)
│   ├── modules/i18n.nix
│   ├── modules/home-manager.nix
│   └── modules/nix-settings.nix
└── [host-specific modules]
```

**Home Manager Level** (`hosts/<hostname>/home.nix`):
```
home.nix
├── modules/home/defaults.nix (all hosts)
│   ├── modules/home/user.nix
│   ├── modules/home/zsh.nix
│   ├── modules/home/git.nix
│   └── modules/home/helix.nix
└── [host-specific home modules]
```

### Host Configurations

| Host | Architecture | Role | Key Features |
|------|-------------|------|--------------|
| **red-miso** | x86_64-linux | Desktop workstation | Cosmic DE, Docker/Podman, Tailscale, development tools |
| **backpfeifengesicht** | x86_64-linux | Workstation | GNOME, GNOME Remote Desktop, Docker/Podman |
| **cafo** | aarch64-linux | Web server (public) | Traefik, Authelia (2FA, Podman container), ttyd |
| **monomyth** | aarch64-linux | Lightweight server | Minimal config |

### Networking

All hosts run Tailscale (`services.tailscale.enable` in `modules/defaults.nix`) and reach each other via their MagicDNS hostnames.

### Secrets Management (SOPS)

Secrets are stored in a separate private repository (`secrets` input) and encrypted with age.

**Access pattern:**
```nix
# In configuration.nix
sops.secrets."path/to/secret" = { };

# Reference in config
services.foo.passwordFile = config.sops.secrets."path/to/secret".path;
```

**Secret structure:**
- `authelia/*` - Web authentication secrets (JWT, storage, passwords, SMTP, Duo)

### Web Service Stack (gestaltzerfall & cafo)

```
Internet
  ↓
Traefik (reverse proxy, Let's Encrypt SSL, routing)
  ├── auth.milanmueller.de → Authelia (2FA with Duo)
  ├── gestaltzerfall.milanmueller.de → ttyd (terminal-in-browser, protected by Authelia)
  └── traefik.milanmueller.de → Dashboard (protected by Authelia)
```

**Important files:**
- `modules/web/traefik.nix` - Reverse proxy configuration
- `modules/web/authelia.nix` - 2FA authentication server
- `modules/web/ttyd.nix` - Terminal service
- `hosts/<hostname>/web/parameters.nix` - Per-host web service parameters (ports, data directories)

## Important Conventions

### User Configuration

All hosts use a single user defined in `flake.nix`:
```nix
userConfig = {
  username = "milan";
  homeDir = "/home/milan";
};
```

This is passed to all modules via `specialArgs`.

### Color Scheme Management (nix-colors)

This configuration uses the `nix-colors` flake input for centralized, declarative theming across all applications.

**Architecture:**
- `nix-colors` provides base16 color schemes as Nix attribute sets
- Default scheme: `catppuccin-latte` (light theme, set in `modules/home/defaults.nix`)
- Per-host override: Set `colorScheme = inputs.nix-colors.colorSchemes.<scheme-name>` in `home.nix`
- Color palette accessible via `config.colorScheme.palette` in all Home Manager modules

**Base16 Color Mapping:**
The `config.colorScheme.palette` attribute set provides 16 colors:
- `base00` - Default background
- `base01` - Lighter background (status bars, line numbers)
- `base02` - Selection background
- `base03` - Comments, invisibles, line highlighting
- `base04` - Dark foreground (status bars)
- `base05` - Default foreground
- `base06` - Light foreground (rare)
- `base07` - Light background (rare)
- `base08` - Red (variables, errors, deletes)
- `base09` - Orange (integers, booleans, constants)
- `base0A` - Yellow (classes, types, warnings)
- `base0B` - Green (strings, success, additions)
- `base0C` - Cyan (operators, escapes, support)
- `base0D` - Blue (functions, keywords, links)
- `base0E` - Magenta (keywords, storage, selectors)
- `base0F` - Brown (deprecated, embedded, special)

**Themed Applications:**

All themed modules are in `modules/home/` and follow the same pattern:

1. **Helix** (`modules/home/helix.nix`):
   - Custom theme: `base16_custom`
   - Maps base16 colors to Helix's syntax highlighting and UI elements
   - Includes comprehensive palette definition for all editor UI components

2. **Zed** (`modules/home/zed.nix`):
   - Most complex theming implementation
   - Generates full Zed theme JSON with ~400+ UI element mappings
   - Detects light/dark theme automatically from scheme name
   - Writes to `~/.config/zed/themes/base16-custom.json`
   - Covers: editor, UI, syntax, terminal colors, collaboration cursors

3. **Zsh/Starship** (`modules/home/zsh.nix`):
   - Starship prompt uses base16 colors for:
     - Username/hostname (base0D)
     - Directory paths (base0B)
     - Git branch (base0E)
     - Git status (base0A)
     - Nix shell indicator (base0C)
     - Success/error symbols (base0B/base08)
   - ZSH syntax highlighting colors (currently commented out)

4. **Firefox** (`modules/home/firefox.nix`):
   - Uses `userChrome.css` for UI theming
   - Uses `userContent.css` for Firefox internal pages (`about:*`)
   - Requires `toolkit.legacyUserProfileCustomizations.stylesheets = true`
   - Themes: tabs, toolbars, URL bar, menus, scrollbars, popups

**Adding Theming to New Applications:**

When adding a new themed module, follow this pattern:

```nix
{ config, lib, pkgs, ... }:

let
  inherit (config.colorScheme) palette;
in
{
  programs.myapp = {
    enable = true;
    # Map base16 colors to app-specific format
    theme = {
      background = "#${palette.base00}";
      foreground = "#${palette.base05}";
      accent = "#${palette.base0D}";
      # ... etc
    };
  };
}
```

**Light/Dark Detection:**

Some apps need to know if the theme is light or dark. Use this pattern:

```nix
isLightTheme =
  let
    schemeName = lib.toLower (config.colorScheme.slug or config.colorScheme.name or "");
  in
  lib.hasInfix "latte" schemeName
  || lib.hasInfix "light" schemeName;
```

**Finding Available Schemes:**

All available color schemes are in the `nix-colors` repository:
- Browse: https://github.com/tinted-theming/schemes
- Use in config: `inputs.nix-colors.colorSchemes.<scheme-slug>`
- Common schemes: `catppuccin-latte`, `catppuccin-mocha`, `gruvbox-dark-hard`, `nord`, `dracula`

### State Versions

Each host declares `system.stateVersion` (e.g., "24.05", "24.11"). **Never change this after initial setup** - it prevents breaking changes during NixOS upgrades.

### File Naming

- Modules: lowercase, descriptive (e.g., `git.nix`, `traefik.nix`)
- Hosts: creative names (red-miso, backpfeifengesicht, cafo, monomyth)
- Imports: relative paths from repo root (e.g., `../../modules/defaults.nix`)

### Commented Features

Some modules are commented out in `modules/defaults.nix`:
- `./zerotier.nix` - Disabled in favor of Tailscale
- `./sshd.nix` - Imported selectively per-host instead

## Working with This Codebase

### Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Add `configuration.nix` (import `../../modules/defaults.nix`)
3. Generate `hardware-configuration.nix` with `nixos-generate-config`
4. Add `home.nix` (import `../../modules/home/defaults.nix`)
5. Add host entry to `flake.nix` hosts attribute set
6. Join the host to the tailnet (`sudo tailscale up`)

### Adding a New Module

**System module:**
1. Create `modules/<module-name>.nix`
2. Import in `modules/defaults.nix` or per-host in `configuration.nix`

**Home Manager module:**
1. Create `modules/home/<module-name>.nix`
2. Import in `modules/home/defaults.nix` or per-host in `home.nix`

### Modifying Secrets

Secrets are in a separate private repository. To add/modify:
1. Clone the `secrets` repository
2. Use `sops` CLI to edit encrypted files
3. Reference new secrets in configurations with `sops.secrets."path/to/secret"`
4. Update `secrets` flake input: `nix flake update secrets`

### Testing Configuration Changes

Before deploying to production systems:
```bash
# Build without activating
sudo nixos-rebuild build

# Test temporarily (revert on reboot)
sudo nixos-rebuild test

# Activate permanently
sudo nixos-rebuild switch
```

For multi-host changes:
1. Test on one host first
2. Commit and push changes
3. On each other host: `git pull && sudo nixos-rebuild switch`

## Home Manager Integration

Home Manager runs as a NixOS module (not standalone):
```nix
# In flake.nix mkHost template
home-manager.users.${userConfig.username}.imports = [
  hosts/${name}/home.nix
  nix-colors.homeManagerModules.default
];
```

**Settings:**
- `useGlobalPkgs = true` - Use system nixpkgs (not home-manager's)
- `useUserPackages = true` - Install to user profile path

## Automated Systems

### Auto-pull Service

`modules/autopull.nix` (imported by some hosts):
- Systemd timer runs daily at 02:00
- Pulls latest changes from git
- Does NOT automatically rebuild (manual intervention required)

## Current Work

Active branch: `cosmic-base16`

In progress (from git status):
- Cosmic Desktop Environment theme integration
- Base16 color scheme support for Cosmic (WIP in `overlays/cosmic-themes-base16/`)
- Module refinements (zsh, git, helix-languages)

Recent focus areas (from commit history):
- Cosmic DE customization and configuration
- Consolidating web services
- Cleaning up experimental configurations
- Replacing Zerotier/WireGuard with Tailscale
