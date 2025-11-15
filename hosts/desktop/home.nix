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

          # teamspeak3
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
