{ user, ... }: {
  home-manager.users.${user}.programs.opencode = {
    enable = true;
    settings = {
      enabled_providers = [
        "ollama"
      ];
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "devstral-small-2:latest" = {
              name = "devstral-small";
            };
          };
        };
      };
    };
  };

  services.ollama = {
    enable = true;
    loadModels = [
      "devstral-small-2:latest"
    ];
  };
}
