{ user, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    playwright-mcp
  ];

  home-manager.users.${user} = {
    programs.opencode = {
      enable = true;
      settings = {
        provider = {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (local)";
            options.baseURL = "http://localhost:11434/v1";
            models = {
              "hf.co/InternScience/Agents-A1-4B-Q4_K_M-GGUF:Q4_K_M" = {
                name = "Agents A1 4B Q4_K_M";
              };
            };
          };

          # Live model catalog is fetched at startup from api.tensorx.ai by
          # plugins/tensorx-models.ts (see home.file below), including limits,
          # capabilities and pricing. The key comes from ~/.secrets, injected
          # by the plugin before providers are built - no secret in this file.
          tensorx = {
            npm = "@ai-sdk/openai-compatible";
            name = "TensorX";
          };
        };
      };
    };

    # Discovers the live TensorX model list at startup: adds models newer than
    # the models.dev snapshot and drops ones the API no longer serves. Reads the
    # API key from ~/.secrets at runtime, so no secret lands in the Nix store.
    home.file.".config/opencode/plugins/tensorx-models.ts".text =
      builtins.readFile ./tensorx-models.ts;
  };

  services.ollama = {
    enable = true;
    loadModels = [
      "devstral-small-2:latest"
      "hf.co/InternScience/Agents-A1-4B-Q4_K_M-GGUF:Q4_K_M"
    ];
  };
}
