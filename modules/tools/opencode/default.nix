{ user, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    playwright-mcp
  ];
  home-manager.users.${user}.programs.opencode = {
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
      };
    };
  };

  services.ollama = {
    enable = true;
    loadModels = [
      "devstral-small-2:latest"
      "hf.co/InternScience/Agents-A1-4B-Q4_K_M-GGUF:Q4_K_M"
    ];
  };
}
