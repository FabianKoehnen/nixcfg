{
  pkgs,
  user,
  lib,
  config,
  ...
}:
{
  services.searx = {
    enable = true;
    environmentFile = "/persist/searx/searxng.env";
    settings = {
      server = {
        bind_address = "127.0.0.1";
      };
      search = {
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        formats = [
          "html"
          "json"
        ];
      };
      # Enabled plugins
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
}
