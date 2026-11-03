# Resolves *.localhost to 127.0.0.1/::1 for real DNS lookups (e.g. `dig`,
# Docker containers, static-linked resolvers), not just glibc/NSS lookups
# (which already synthesize *.localhost via nss-myhostname).
#
# Works by pointing NetworkManager's DNS handling at a local dnsmasq
# instance and dropping a wildcard rule into its config directory.
# Tailscale's MagicDNS resolver (100.100.100.100) forwards non-tailnet
# queries to this dnsmasq, so both work together.
#
# Untracked, machine-local overrides: put hosts-format files into
# /etc/hosts.d/ (e.g. /etc/hosts.d/dev). dnsmasq watches the directory
# via inotify, so changes apply immediately without a rebuild.
{
  networking.networkmanager.dns = "dnsmasq";

  environment.etc."NetworkManager/dnsmasq.d/localhost-wildcard.conf".text = ''
    address=/localhost/127.0.0.1
    address=/localhost/::1
  '';

  environment.etc."NetworkManager/dnsmasq.d/hosts-dir.conf".text = ''
    hostsdir=/etc/hosts.d
  '';

  systemd.tmpfiles.rules = [ "d /etc/hosts.d 0755 root root -" ];
}
