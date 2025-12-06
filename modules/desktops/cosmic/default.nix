{ pkgs
, user
, wallpaper
, inputs
, ...
}: {
  imports = [
    #    ../../tools/cosmic-greet
    ../../tools/darkman
    ../../terminal/kitty
  ];

  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    # pyprland

    libreoffice-fresh
    pkgs.gnome-disk-utility
    baobab
    # polkit-kde-agent
    # okular
    vlc
    libnotify
    xarchiver

    # Audio
    easyeffects
    pamixer
    pavucontrol
    helvum
    playerctl

    # Xfce Tools
    xfce.ristretto
    xfce.thunar
    xfce.xfce4-taskmanager
    xfce.mousepad
    xfce.exo

    #cosmic apps
    quick-webapps
    cosmic-ext-tweaks
    cosmic-ext-ctl
    cosmic-ext-applet-caffeine
    cosmic-ext-applet-external-monitor-brightness
  ];

  home-manager = {
    users.${user} = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
        ./cosmic-manager.nix # "cosmic-manager cosmic2nix" generates a unclean, sometimes buggy config of the current settings
      ];

      home.activation.resetPanels = inputs.home-manager.lib.hm.dag.entryAfter [ "configureCosmic" ] ''
        sleep 1 && exec ${pkgs.procps}/bin/pkill cosmic-panel
      '';

      programs.cosmic-manager.enable = true;

      services.darkman = {
        enable = true;
        darkModeScripts = {
          theme = ''
            echo true > $HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark
          '';
          bg = ''
            echo "(
              output: \"all\",
              source: Path(\"${wallpaper.dark}\"),
              filter_by_theme: false,
              rotation_frequency: 300,
              filter_method: Lanczos,
              scaling_mode: Zoom,
              sampling_method: Alphanumeric,
            )" > "$HOME/.config/cosmic/com.system76.CosmicBackground/v1/all"
          '';
        };
        lightModeScripts = {
          theme = ''
            echo false > $HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark
          '';
          bg = ''
            echo "(
              output: \"all\",
              source: Path(\"${wallpaper.light}\"),
              filter_by_theme: false,
              rotation_frequency: 300,
              filter_method: Lanczos,
              scaling_mode: Zoom,
              sampling_method: Alphanumeric,
            )" > "$HOME/.config/cosmic/com.system76.CosmicBackground/v1/all"
          '';
        };
      };
    };
  };
}


