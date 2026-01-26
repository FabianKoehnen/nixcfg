{ pkgs
, user
, lib
, ...
}: {
  home-manager.users.${user} = {
    config = {
      services.gnome-keyring.enable = true;
      xdg.enable = true;
      home = {
        stateVersion = "24.05";
        packages = with pkgs; [
          piper
        ];
      };

      programs = {
        eza.enable = true;
      };
      services.hypridle.enable = lib.mkForce false;
    };
  };
}
