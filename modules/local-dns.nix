# Resolves *.localhost to 127.0.0.1/::1 for real DNS lookups (e.g. `dig`,
# Docker containers, static-linked resolvers), not just glibc/NSS lookups
# (which already synthesize *.localhost via nss-myhostname).
#
# Works by pointing NetworkManager's DNS handling at a local dnsmasq
# instance and dropping a wildcard rule into its config directory.
{
  networking.networkmanager.dns = "dnsmasq";

  environment.etc."NetworkManager/dnsmasq.d/localhost-wildcard.conf".text = ''
    address=/localhost/127.0.0.1
    address=/localhost/::1
  '';
}
