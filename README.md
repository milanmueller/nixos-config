# Nixos configuration

This repository contains my NixOS configuration, managed using Nix flakes. It’s designed to be modular, clear, and reusable across multiple hosts, with a focus on both system-wide and user-specific (Home Manager) settings.

## Folder Structure
* `/` - the root folder only contains the files `flake.nix` and `flake.lock`
  * `modules` - modules (i.e. programs and configuration) which are shared between machines such as
  * `hosts` - contains the host specific configuration for each machine (including `hardware-configuration.nix`)
    * `red-miso` - daily driver Lenovo Yoga Pro 7i Laptop using cosmic for the desktop
    * `cognitive-contortions` - Odroid HC4 NAS running mirrored zfs and minIO
    * `template` - Minimal configuration with home manager and basic utilities to be used for new hosts.
                   To use, just clone `template` rename it accordingly, extend flake.nix on top-level and adjust
  * `lib` - custom home manager modules

## TODO
* [ ] - Somehow incorporate (sops-nix)[https://github.com/Mic92/sops-nix] to also manage secrets properly.
* [ ] - Once sops is included, move zerotier config to modules to have all hosts joined the same virtual network
* [ ] - Setup some DHCP Server in zerotier network
* [ ] - Create Home Manager module to configure Cosmic (W.I.P)
