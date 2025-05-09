{ pkgs, ... }:
let
  # Define the wrapper script
  helixGptWrapper = pkgs.writeScriptBin "helix-gpt-wrapper" ''
    #!/usr/bin/env bash
    API_KEY=$(${pkgs.coreutils}/bin/cat /run/secrets/ai_stuff/helix_gpt_copilot_key)
    exec ${pkgs.helix-gpt}/bin/helix-gpt --handler copilot --copilotApiKey "$API_KEY" "$@"
  '';
in
{

  helix_lsp = {
    command = "${helixGptWrapper}/bin/helix-gpt-wrapper";
    args = [ ]; # No additional args needed, handled by the wrapper
  };
}
