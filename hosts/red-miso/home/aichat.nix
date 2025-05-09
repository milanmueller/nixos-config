{ lib, pkgs, ... }:
{
  home.file.".config/aichat/config.yaml".text = ''
    model: openrouter:deepseek/deepseek-chat-v3-0324:free
    save: true
    history: true
    compress_threshold: 10000
    clients:
    - type: openai-compatible
      name: openrouter
      api_base: https://openrouter.ai/api/v1
      models:
        - name: deepseek/deepseek-chat-v3-0324:free
          max_input_tokens: 100000
        - name: deepseek/deepseek-r1:free
          max_input_tokens: 100000
  '';
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ai";
      runtimeInputs = [ aichat ];
      text = ''
        OPENROUTER_API_KEY="$(${pkgs.coreutils}/bin/cat /run/secrets/ai_stuff/openrouter_api_key)"
        export OPENROUTER_API_KEY
        exec ${pkgs.aichat}/bin/aichat "$@"
      '';
    })
  ];
}
