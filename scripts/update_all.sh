#!/usr/bin/env bash
# Update all hosts in the NixOS configuration via Tailscale (MagicDNS hostnames)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Get current hostname
CURRENT_HOSTNAME=$(hostname)

# List all hosts defined in the flake
list_hosts() {
    nix eval --raw "$CONFIG_DIR#nixosConfigurations" \
        --apply 'hosts: builtins.concatStringsSep "\n" (builtins.attrNames hosts)'
}

# Function to update a single host
update_host() {
    local hostname=$1

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
        echo -e "${CYAN}Connecting to $hostname via Tailscale...${RESET}"
        if ssh -t "milan@$hostname" "cd ~/nixos-config && git pull && sudo nixos-rebuild switch"; then
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
    local failed=()

    # Update each host, continuing past failures (e.g. offline hosts)
    while read -r hostname; do
        update_host "$hostname" </dev/tty || failed+=("$hostname")
    done < <(list_hosts)

    if [[ ${#failed[@]} -gt 0 ]]; then
        echo -e "${RED}Failed hosts: ${failed[*]}${RESET}"
        exit 1
    fi
}

main "$@"
