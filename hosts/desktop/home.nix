{ pkgs
, unstable
, ...
}: {
  imports = [ ./cosmic.nix ];
  config = {
    xdg = {
      enable = true;
      portal.xdgOpenUsePortal = true;
    };
    home = {
      stateVersion = "23.11";
      packages = with pkgs; [
        unstable.piper
        signal-desktop
        # discord
      ];
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.opencode.settings.mcp.home-assistant = {
      type = "remote";
      url = "https://fabian-nas:8123/api/mcp";
      enabled = false;
      oauth.clientId = "http://127.0.0.1:19876/";
    };
  };
}
