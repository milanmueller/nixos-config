# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a multi-host NixOS configuration managed with Nix Flakes. It configures five different systems (x86_64 and aarch64) with shared modules, centralized secrets management via SOPS, and a WireGuard VPN mesh topology.

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

### Multi-Host Deployment

Update all hosts via WireGuard network (requires WireGuard connectivity):
```bash
cd ~/nixos-config/scripts && ./update_all.sh
```

This Bash script:
- Parses `modules/network/hosts.nix` to extract WireGuard IPs
- For local host: runs `git pull && sudo nixos-rebuild switch`
- For remote hosts: SSH to WireGuard IP and runs same commands

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
│   ├── modules/network/wireguard.nix
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
| **gestaltzerfall** | x86_64-linux | Web server | Traefik, Authelia (2FA), ttyd, CrowdSec, public-facing |
| **cafo** | aarch64-linux | VPN hub + web services | WireGuard central node (port 51821), same web stack as gestaltzerfall |
| **monomyth** | aarch64-linux | Lightweight server | Minimal config, WireGuard client |
| **odessa** | aarch64-linux | Lightweight server | Minimal config, WireGuard client |

### WireGuard Network Topology

All hosts connect via WireGuard in a hub-spoke model:
- **Central node:** `cafo` (10.0.0.5:51821)
- **Clients:** red-miso, gestaltzerfall, monomyth, odessa
- **MTU:** 1280 (prevents SSH authentication issues)
- **Security:** Pre-shared keys (PSK) from SOPS secrets
- **Configuration:** `modules/network/wireguard.nix` + `modules/network/hosts.nix`

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
- `wireguard/psk` - Shared pre-shared key
- `wireguard/<hostname>/private_key` - Per-host WireGuard keys
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

### Color Scheme Management

Uses `nix-colors` for centralized theme management:
- Default: `catppuccin-latte` (set in `modules/home/defaults.nix`)
- Override per-host by setting `colorScheme` in `home.nix`
- Helix editor uses custom `base16_custom` theme mapped to color scheme

### State Versions

Each host declares `system.stateVersion` (e.g., "24.05", "24.11"). **Never change this after initial setup** - it prevents breaking changes during NixOS upgrades.

### File Naming

- Modules: lowercase, descriptive (e.g., `git.nix`, `wireguard.nix`)
- Hosts: creative names (red-miso, gestaltzerfall, cafo, monomyth, odessa)
- Imports: relative paths from repo root (e.g., `../../modules/defaults.nix`)

### Commented Features

Some modules are commented out in `modules/defaults.nix`:
- `./zerotier.nix` - Disabled in favor of WireGuard
- `./sshd.nix` - Imported selectively per-host instead

## Working with This Codebase

### Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Add `configuration.nix` (import `../../modules/defaults.nix`)
3. Generate `hardware-configuration.nix` with `nixos-generate-config`
4. Add `home.nix` (import `../../modules/home/defaults.nix`)
5. Add host entry to `flake.nix` hosts attribute set
6. Add WireGuard config to `modules/network/hosts.nix`
7. Generate WireGuard keys and add to secrets repository

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
3. Run `nix run .#update-all` to deploy to all hosts

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

### Multi-host Update Script

`scripts/update_all.sh`:
- Written in Bash
- Parses `modules/network/hosts.nix` for WireGuard IPs
- SSH to each host and run `git pull && sudo nixos-rebuild switch`
- Handles failures gracefully with colored output

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
- Disabling Zerotier in favor of WireGuard
