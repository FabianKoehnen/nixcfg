{ pkgs
, user
, ...
}: {
  home-manager.users.${user} = {
    config = {
      xdg.enable = true;
      home = {
        stateVersion = "23.11";
        packages = with pkgs; [
          piper

          # teamspeak_client
          signal-desktop
          discord
        ];
      };

      programs = {
        eza.enable = true;
      };
    };
  };
}
