{ user
, pkgs
, lib
, ...
}:
let
  colors = {
    rosewater = "F5E0DC";
    flamingo = "F2CDCD";
    pink = "F5C2E7";
    mauve = "DDB6F2";
    red = "F28FAD";
    maroon = "E8A2AF";
    peach = "F8BD96";
    yellow = "FAE3B0";
    green = "ABE9B3";
    teal = "B5E8E0";
    blue = "96CDFB";
    sky = "89DCEB";
    lavender = "C9CBFF";
    black0 = "0D1416"; # crust
    black1 = "111719"; # mantle
    black2 = "131A1C"; # base
    black3 = "192022"; # surface0
    black4 = "202729"; # surface1
    gray0 = "363D3E"; # surface2
    gray1 = "4A5051"; # overlay0
    gray2 = "5C6262"; # overlay1
    white = "C5C8C9"; # text
  };

  xcolors = lib.mapAttrsRecursive (_: color: "#${color}") colors;
in
{
  home-manager.users.${user}.programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        fixed-center = true;
        # gtk-layer-shell = true;
        spacing = 0;
        height = 10;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [
          "image"
          "idle_inhibitor"
          "hyprland/workspaces"
          "gamemode"
        ];
        modules-center = [
          "clock"
          "privacy"
        ];
        modules-right = [
          "cpu"
          "memory"
          "group/network-modules"
          "group/wireplumber-modules"
          "group/backlight-modules"
          "group/battery-modules"
          "custom/headsetcontrol"
          "tray"
          "custom/notification"
          # "group/powermenu"
        ];

        "image" = {
          path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          size = 16;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{id}";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        cpu = {
          format = "Cpu: {usage}%";
          tooltip = true;
          interval = 1;
          on-click = "${pkgs.btop}/bin/btop";
        };
        memory = {
          format = "Mem: {used:0.1f}Gi";
          on-click = "${pkgs.btop}/bin/btop";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          "format-icons" = {
            notification = "󱅫 ";
            none = " ";
            "dnd-notification" = " ";
            "dnd-none" = "󰂛 ";
            "inhibited-notification" = " ";
            "inhibited-none" = " ";
            "dnd-inhibited-notification" = " ";
            "dnd-inhibited-none" = " ";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          exec = "swaync-client -swb";
          "on-click" = "sleep 0.1 && swaync-client -t -sw";
          "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
          escape = true;
        };

        "group/network-modules" = {
          modules = [
            "network#icon"
            "network#address"
          ];
          orientation = "inherit";
        };
        "network#icon" = {
          format-disconnected = "󰤮 ";
          format-ethernet = "󰈀 ";
          format-wifi = "󰤨 ";
          tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };
        "network#address" = {
          format-disconnected = "Disconnected";
          format-ethernet = "{ipaddr}/{cidr}";
          format-wifi = "{essid}";
          tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-disconnected = "Disconnected";
        };

        "group/wireplumber-modules" = {
          modules = [
            "wireplumber#icon"
            "wireplumber#volume"
          ];
          orientation = "inherit";
        };
        "wireplumber#icon" = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle &> /dev/null";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%+ &> /dev/null";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%- &> /dev/null";
          tooltip-format = "Volume: {volume}%";
        };
        "wireplumber#volume" = {
          format = "{volume}%";
          tooltip-format = "Volume: {volume}%";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "group/backlight-modules" = {
          modules = [
            "custom/darkman"
            "backlight#percent"
          ];
          orientation = "inherit";
        };
        "backlight#icon" = {
          format = "{icon}";
          format-icons = [
            "󰃞 "
            "󰃟 "
            "󰃠 "
          ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ &> /dev/null";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- &> /dev/null";
          tooltip-format = "Backlight: {percent}%";
        };
        "backlight#percent" = {
          format = "{percent}%";
          tooltip-format = "Backlight: {percent}%";
        };
        "custom/darkman" = {
          format = "{icon}";
          format-icons = {
            light = "☀️";
            dark = "🌙";
          };
          exec-if = "which ${pkgs.darkman}/bin/darkman";
          exec =
            let
              script = pkgs.writeShellScriptBin "darkman-json.sh" ''
                set -euo pipefail
                readonly MODE=$(${pkgs.darkman}/bin/darkman get)
                printf '{"text":"%s", "alt": "%s"}' "$MODE" "$MODE"
              '';
            in
            "${script}/bin/darkman-json.sh";
          return-type = "json";
          interval = 30;
          on-click = "darkman toggle";
          tooltip-format = "Current Mode: {text}";
        };
        "custom/headsetcontrol" = {
          exec-if = "${pkgs.headsetcontrol}/bin/headsetcontrol --connected";
          exec =
            let
              script = pkgs.writeShellScriptBin "headsetcontrol-json.sh" ''
                set -euo pipefail

                eval "$(headsetcontrol --output env 2>/dev/null)"

                battery_level="''${DEVICE_0_BATTERY_LEVEL:-N/A}"
                battery_status="''${DEVICE_0_BATTERY_STATUS:-unknown}"
                device_name="''${DEVICE_0_NAME:-Unknown Headset}"

                if [[ "$battery_level" == "N/A" ]]; then
                  echo '{"text": "🎧 N/A", "tooltip": "Headset not detected"}'
                else
                  icon="🎧"
                  [[ "$battery_status" == "charging" ]] && icon="🔌🎧"
                  echo "{\"text\": \"$icon $battery_level%\", \"tooltip\": \"$device_name: $battery_level% ($battery_status)\"}"
                fi
              '';
            in
            "${script}/bin/headsetcontrol-json.sh";
          on-click = "${pkgs.headsetcontrol}/bin/headsetcontrol -s 128";
          return-type = "json";
          interval = 30;
        };
        "group/battery-modules" = {
          modules = [
            "battery#icon"
            "battery#capacity"
          ];
          orientation = "inherit";
        };
        "battery#icon" = {
          format = "{icon}";
          format-charging = "󱐋";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = "󰚥";
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip-format = "{timeTo}, {capacity}%";
        };
        "battery#capacity" = {
          format = "{capacity}%";
          tooltip-format = "{timeTo}, {capacity}%";
        };

        tray = {
          icon-size = 24;
          spacing = 10;
          show-passive-items = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${xcolors.white}'><b>{}</b></span>";
              days = "<span color='${xcolors.gray1}'><b>{}</b></span>";
              weeks = "<span color='${xcolors.sky}'><b>W{}</b></span>";
              weekdays = "<span color='${xcolors.blue}'><b>{}</b></span>";
              today = "<span color='${xcolors.yellow}'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
      };
    };

    style = ''
      /* Global */
      * {
        all: unset;
        font-family: "GeistMono Nerd Font Propo", sans-serif;
        font-size: 9pt;
        font-weight: 500;
      }

      /* Menu */
      menu {
        background: ${xcolors.black0};
        border-radius: 12px;
      }

      menu separator {
        background: ${xcolors.black3};
      }

      menu menuitem {
        background: transparent;
        padding: 0.5rem;
        transition: 300ms linear;
      }

      menu menuitem:hover {
        background: lighter(${xcolors.black3});
      }

      menu menuitem:first-child {
        border-radius: 12px 12px 0 0;
      }

      menu menuitem:last-child {
        border-radius: 0 0 12px 12px;
      }

      menu menuitem:only-child {
        border-radius: 12px;
      }

      /* Tooltip */
      tooltip {
        background: ${xcolors.black0};
        border-radius: 12px;
      }

      tooltip label {
        margin: 0.25rem;
      }

      /* Waybar */
      window#waybar {
        background: ${xcolors.black0};
      }

      .modules-left {
        padding-left: 0.25rem;
      }

      .modules-right {
        padding-right: 0.25rem;
      }

      /* Modules */
      #workspaces,
      #workspaces button,
      #idle_inhibitor,
      #cpu,
      #memory,
      #network-modules,
      #wireplumber-modules,
      #backlight-modules,
      #battery-modules,
      #tray,
      #clock,
      #custom-notification {
        background: ${xcolors.black3};
        border-radius: 8px;
        margin: 0.2rem 0.15rem;
        transition: 300ms linear;
      }

      #image,
      #window,
      #cpu,
      #memory,
      #network.address,
      #wireplumber.volume,
      #backlight.percent,
      #battery.capacity,
      #tray,
      #clock {
        padding: 0.25rem 0.5rem;
      }

      #idle_inhibitor,
      #network.icon,
      #wireplumber.icon,
      #backlight.icon,
      #battery.icon,
      #custom-darkman,
      #custom-notification {
        background: ${xcolors.blue};
        color: ${xcolors.black3};
        border-radius: 8px;
        font-size: 13pt;
        padding: 0.15rem;
        min-width: 1rem;
        transition: 300ms linear;
      }

      /* Workspaces */
      #workspaces button {
        margin: 0;
        padding: 0.15rem;
        min-width: 1rem;
      }

      #workspaces button label {
        color: ${xcolors.white};
      }

      #workspaces button.empty label {
        color: ${xcolors.gray0};
      }

      #workspaces button.urgent label,
      #workspaces button.active label {
        color: ${xcolors.black3};
      }

      #workspaces button.urgent {
        background: ${xcolors.red};
      }

      #workspaces button.active {
        background: ${xcolors.blue};
      }

      /* Idle Inhibitor */
      #idle_inhibitor {
        background: ${xcolors.black3};
        color: ${xcolors.blue};
      }

      #idle_inhibitor.deactivated {
        color: ${xcolors.gray0};
      }

      /* Systray */
      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: ${xcolors.red};
      }

      /* Hover effects */
      #workspaces button:hover,
      #idle_inhibitor:hover,
      #idle_inhibitor.deactivated:hover,
      #cpu:hover,
      #memory:hover,
      #clock:hover {
        background: lighter(${xcolors.black3});
      }

      #workspaces button.urgent:hover {
        background: lighter(${xcolors.red});
      }

      #workspaces button.active:hover,
      #network.icon:hover,
      #wireplumber.icon:hover,
      #battery.icon:hover,
      #custom-darkman:hover,
      #custom-notification:hover,
      #custom-notification.cc-open {
        background: lighter(${xcolors.blue});
      }

      #workspaces button.urgent:hover label,
      #workspaces button.active:hover label,
      #network.icon:hover label,
      #wireplumber.icon:hover label,
      #battery.icon:hover label,
      #custom-darkman:hover label,
      #custom-notification:hover label,
      #custom-notification.cc-open label {
        color: lighter(${xcolors.black3});
      }

      #workspaces button:hover label {
        color: lighter(${xcolors.white});
      }

      #workspaces button.empty:hover label {
        color: lighter(${xcolors.gray0});
      }

      #idle_inhibitor:hover {
        color: lighter(${xcolors.blue});
      }

      #idle_inhibitor.deactivated:hover {
        color: lighter(${xcolors.gray0});
      }

      #custom-notification {
        font-size: 10px
      }
    '';
  };
}
