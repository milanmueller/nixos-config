#!/usr/bin/env bash
# Update all hosts in the NixOS configuration via WireGuard network

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
HOSTS_FILE="$CONFIG_DIR/modules/network/hosts.nix"

# Get current hostname
CURRENT_HOSTNAME=$(hostname)

# Function to parse hosts.nix and extract hostname->IP mappings
parse_hosts() {
    # Parse the hosts.nix file to extract hostname and wireguardIp
    # Format: hostname = { ... wireguardIp = "10.0.0.X"; ... };
    awk '
        /^  [a-z-]+ = {/ {
            # Extract hostname (remove " = {")
            hostname = $1
            in_host = 1
            ip = ""
        }
        in_host && /wireguardIp = / {
            # Extract IP (remove quotes and semicolon)
            gsub(/[";]/, "", $3)
            ip = $3
        }
        in_host && /^  };/ {
            # End of host block
            if (ip != "") {
                print hostname " " ip
            }
            in_host = 0
        }
    ' "$HOSTS_FILE"
}

# Function to update a single host
update_host() {
    local hostname=$1
    local ip=$2

    if [[ "$hostname" == "$CURRENT_HOSTNAME" ]]; then
        echo -e "${CYAN}Running locally on $hostname...${RESET}"
        if cd "$CONFIG_DIR" && git pull && sudo nixos-rebuild switch; then
            echo -e "${GREEN}Finished updating $hostname${RESET}\n"
            return 0
        else
            echo -e "${RED}Failed to update $hostname (exit code: $?)${RESET}\n"
            return 1
        fi
    else
        echo -e "${CYAN}Connecting to $hostname at $ip...${RESET}"
        if ssh -t "milan@$ip" "cd ~/nixos-config && git pull && sudo nixos-rebuild switch"; then
            echo -e "${GREEN}Finished updating $hostname${RESET}\n"
            return 0
        else
            echo -e "${RED}Failed to update $hostname (exit code: $?)${RESET}\n"
            return 1
        fi
    fi
}

# Main logic
main() {
    # Check if hosts file exists
    if [[ ! -f "$HOSTS_FILE" ]]; then
        echo -e "${RED}Error: hosts.nix not found at $HOSTS_FILE${RESET}"
        exit 1
    fi

    # Parse hosts and update each one
    while read -r hostname ip; do
        update_host "$hostname" "$ip"
    done < <(parse_hosts)
}

main "$@"
