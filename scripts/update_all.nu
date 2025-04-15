# Read and parse hosts.nix to get WireGuard IPs
def parse_hosts [] {
  # Read hosts.nix and convert to NUON-like format
  let hosts_content = open ~/nixos-config/modules/network/hosts.nix
    | str replace -r -a '=\s*{' ': {'  # Replace '= {' with ': {'
    | str replace -r -a ';' ''         # Remove semicolons
    | str replace -r -a '\s*=\s*' ': ' # Replace ' = ' with ': '
  # Parse as NUON
  let hosts = ($hosts_content | from nuon)
  # Convert to table with hostname and ip
  $hosts
  | transpose hostname attrs
  | select hostname attrs.wireguardIp
  | rename hostname ip
}

# Main function to update each host
def main [] {
  let current_hostname = (hostname)  # Get current machine's hostname
  let hosts = parse_hosts
  for $host in $hosts {
    if $host.hostname == $current_hostname {
      print (ansi cyan) $"Running locally on ($host.hostname)..." (ansi reset)
      try {
        # Run commands locally
        cd ~/nixos-config
        git pull
        sudo nixos-rebuild switch
        print (ansi green) $"Finished updating ($host.hostname)\n" (ansi reset)
      } catch {
        print (ansi red) $"Failed to update ($host.hostname): ($env.LAST_EXIT_CODE)\n" (ansi reset)
      }
    } else {
      print (ansi cyan) $"Connecting to ($host.hostname) at ($host.ip)..." (ansi reset)
      try {
        ssh -t $"milan@($host.ip)" "
          cd ~/nixos-config;
          git pull;
          sudo nixos-rebuild switch
        "
        print (ansi green) $"Finished updating ($host.hostname)\n" (ansi reset)
      } catch {
        print (ansi red) $"Failed to update ($host.hostname): ($env.LAST_EXIT_CODE)\n" (ansi reset)
      }
    }
  }
}
