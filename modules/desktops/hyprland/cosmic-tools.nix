{ home-manager
, inputs
, pkgs
, user
, lib
, unstable
, config
, ...
}: {
  environment.systemPackages = with unstable; [
    adwaita-icon-theme
    cosmic-applets
    cosmic-settings
    cosmic-randr
    cosmic-panel
    cosmic-screenshot
    cosmic-settings-daemon
    cosmic-osd
    cosmic-notifications
    cosmic-edit
    cosmic-session
    alsa-utils
    cosmic-applibrary
    hicolor-icon-theme
    playerctl
    pop-icon-theme
  ];

  services.libinput.enable = true;
  xdg.mime.enable = true;
  xdg.icons.enable = true;

  programs.dconf.enable = lib.mkDefault true;

  # required dbus services
  services.accounts-daemon.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = lib.mkDefault (!config.hardware.system76.power-daemon.enable);
  security.polkit.enable = true;
  security.rtkit.enable = true;
}
