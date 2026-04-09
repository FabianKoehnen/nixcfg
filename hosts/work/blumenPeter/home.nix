{ pkgs
, unstable
, user
, ...
}: {
  home-manager.users.${user} = {
    config = {
      xdg.enable = true;
      home = {
        stateVersion = "23.11";
        packages = with pkgs; [
          unstable.piper
          signal-desktop
          discord
        ];


        # https://github.com/ddev/ddev/issues/8183
        file = {
          ".docker/cli-plugins/docker-buildx" = {
            source = "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
          };
          ".docker/cli-plugins/docker-compose" = {
            source = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
          };
        };
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
