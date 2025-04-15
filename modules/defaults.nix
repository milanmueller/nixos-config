{ config, pkgs, ... }:
{
  imports = [
    ./i18n.nix
    ./zerotier.nix
    ./network/wireguard.nix
    ./home-manager.nix
    ./nix-settings.nix
    ./sshd.nix
  ];
}
