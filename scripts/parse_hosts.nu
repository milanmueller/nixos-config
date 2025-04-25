#!/usr/bin/env nu
# scripts/parse_hosts.nu

def main [] {
  # Read flake.nix as raw text
  let flake_path = $"($env.HOME)/nixos-config/flake.nix"
  let flake_content = open $flake_path --raw

  # Extract hosts block
  # Match 'hosts = {' until the corresponding '};' at the same brace level
  let hosts_block = $flake_content
    | parse -r 'hosts\s*=\s*\{((?:[^{}]|\{[^{}]*\})*)\};'
    | get capture0.0?
    | str trim

  if ($hosts_block | is-empty) {
    print (ansi red) "Error: Could not parse hosts block from flake.nix" (ansi reset)
    exit 1
  }

  # Convert Nix syntax to NUON-like format
  let cleaned_block = $hosts_block
    | str replace -r -a '=\s*\{' ': {'       # Replace '= {' with ': {'
    | str replace -r -a ';\s*' ''            # Remove semicolons
    | str replace -r -a '\s*=\s*' ': '       # Replace ' = ' with ': '
    | str replace -r -a 'inherit\s+[^;]*;' '' # Remove 'inherit ...;'
    | str replace -r -a '\[\s*([^\]]*)\s*\]' '[$1]' # Normalize lists (remove extra spaces)
    | str replace -r -a 'null' '""'          # Replace Nix 'null' with empty string for NUON
    | str replace -r -a '([a-zA-Z0-9_-]+)\s*:' '"$1":' # Quote keys for JSON compatibility

  # Wrap in braces to make it a valid NUON object
  let nuon_content = $"\{($cleaned_block)\}"

  # Parse as NUON
  let hosts = try {
    $nuon_content | from nuon
  } catch {
    print (ansi red) "Error: Failed to parse hosts as NUON" (ansi reset)
    print $"Parsed content:\n($nuon_content)"
    exit 1
  }

  # Convert to list of {hostname, ip} records
  let host_list = $hosts
    | transpose hostname attrs
    | select hostname attrs.wireguardIp?
    | rename hostname ip
    | update ip { |row| $row.ip | default "" } # Replace missing/null IPs with empty string

  # Output as JSON
  $host_list | to json
}
