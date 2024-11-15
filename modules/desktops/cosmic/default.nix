{ config
, pkgs
, unstable
, user
, ...
}: {

  environment.systemPackages = with pkgs; [
    # pyprland

    libreoffice-fresh
    gnome.gnome-disk-utility
    baobab
    # polkit-kde-agent
    okular
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
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
