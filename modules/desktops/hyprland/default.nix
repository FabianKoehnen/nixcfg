{ home-manager, inputs, pkgs, hyprpkgs, user, ... }:
{
  imports = [
    ../../tools/rofi
    ../../tools/thunar
  ];
  

  environment.systemPackages = with pkgs; [
    # Audio
    easyeffects

    # Sreenshot
    hyprpkgs.grimblast

    # Clipboard
    cliphist
    wl-clipboard

    # Wallpaper
    hyprpaper
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  xdg.portal.enable = true;


  ##################
  ## home-manager ##
  ##################
  home-manager = {
    sharedModules = [
      inputs.hyprland.homeManagerModules.default
    ];
    users.${user} = {
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./hyprland.conf;
      };

      services = {
        dunst = {
          enable = true;
        };
      };

      programs = {
        eww = {
          enable = true;
          package = pkgs.eww-wayland;
          configDir = ./eww;
        };
      };
    };
  };
}