{ pkgs, hyprland, inputs, user, ... }:

{ 
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };
  home-manager.users.${user} = {
    config = {
      xdg.enable = true;
      home = {
        stateVersion = "23.11";
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
          
          teamspeak5_client
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