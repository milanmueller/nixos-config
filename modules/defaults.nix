{
  pkgs,
  userConfig,
  ...
}:
{
  imports = [
    ./i18n.nix
    ./home-manager.nix
    ./nix-settings.nix
    # ./sshd.nix
  ];
  # Networking
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable Tailscale to connect devices
  services.tailscale.enable = true;

  # Sudo configuration
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  # Terminfo for ghostty, so SSH sessions from ghostty (TERM=xterm-ghostty) work
  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  # Install zsh
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = "Milan Müller";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      # backpfeifengesicht
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6rv4EpRjBsTp0bFdVFH9XkMldp9tIJQovJ0+neSl34 mail@milanmueller.de"
      # red-miso
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPa/zAzWTWo8wKuUnjMkUFk/W0e01a5JBdgREd8TMNTn mail@milanmueller.de"
    ];
    shell = pkgs.zsh;
  };
}
