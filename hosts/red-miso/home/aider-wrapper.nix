{ pkgs, ... }:
{
  home.file.".aider.model.settings.yml".text = ''
    - name: openrouter/deepseek/deepseek-chat-v3-0324:free
      edit_format: diff
      weak_model_name: openrouter/deepseek/deepseek-chat-v3-0324:free
      use_repo_map: true
      examples_as_sys_msg: true
      caches_by_default: true
      extra_params:
        max_tokens: 8192
      use_temperature: false
      editor_model_name: openrouter/deepseek/deepseek-r1:free
      editor_edit_format: editor-diff
  '';
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "alder";
      runtimeInputs = [ aider-chat ];
      text = ''
        OPENROUTER_API_KEY=$(${pkgs.coreutils}/bin/cat /run/secrets/ai_stuff/openrouter_api_key)
        exec  ${pkgs.aider-chat}/bin/aider --model openrouter/deepseek/deepseek-chat-v3-0324:free --api-key "openrouter=$OPENROUTER_API_KEY" --vim "$@"
      '';
    })
  ];
}
