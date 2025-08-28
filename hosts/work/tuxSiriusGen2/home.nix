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
        sessionVariables = {
          GDK_BACKEND = "wayland,x11";
          QT_QPA_PLATFORM = "wayland;xcb";
          CLUTTER_BACKEND = "wayland";
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
          WLR_NO_HARDWARE_CURSORS = "1";
        };
        packages = with pkgs; [
          piper

          teamspeak_client
          signal-desktop
          discord
        ];
      };

      programs = {
        eza.enable = true;
      };
      services.hypridle.enable = lib.mkForce false;
    };
  };
}
