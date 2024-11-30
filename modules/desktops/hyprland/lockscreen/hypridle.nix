{ pkgs
, user
, config
, ...
}: {
  home-manager.users.${user}.services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10 | true"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r | true"; # monitor backlight restore.
        }
        {
          timeout = 150; # 2.5min.
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0 | true"; # turn off keyboard backlight.
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight | true"; # turn on keyboard backlight.
        }
        {
          timeout = 900; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 930; # 5.5min
          on-timeout = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 2700; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };
}
