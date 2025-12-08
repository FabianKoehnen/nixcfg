{ cosmicLib, wallpaper, ... }:
{
  imports = [ ./theme.nix ];
  wayland.desktopManager.cosmic = {
    enable = true;
    configFile = {
      "com.system76.CosmicComp" = {
        version = 1;
        entries = {
          pinned_workspaces = cosmicLib.cosmic.mkRON "raw" "[]";
          autotile_behavior = cosmicLib.cosmic.mkRON "raw" "PerWorkspace";
          # accessibility_zoom = cosmicLib.cosmic.mkRON "raw" "(\n    start_on_login: false,\n    show_overlay: false,\n    increment: 25,\n    view_moves: Continuously,\n    enable_mouse_zoom_shortcuts: false,\n)";
          accessibility_zoom = cosmicLib.cosmic.mkRON "raw" ''(
              start_on_login: false,
              show_overlay: false,
              increment: 25,
              view_moves: Continuously,
              enable_mouse_zoom_shortcuts: false,
          )'';
          active_hint = true;
          descale_xwayland = cosmicLib.cosmic.mkRON "raw" "r#true";
          autotile = true;
          focus_follows_cursor_delay = 100;
          # xkb_config = cosmicLib.cosmic.mkRON "raw" "(\n    rules: \"\",\n    model: \"pc104\",\n    layout: \"eu\",\n    variant: \"\",\n    options: Some(\"terminate:ctrl_alt_bksp\"),\n    repeat_delay: 600,\n    repeat_rate: 25,\n)";
          xkb_config = cosmicLib.cosmic.mkRON "raw" ''(
              rules: "",
              model: "pc104",
              layout: "eu",
              variant: "",
              options: Some("terminate:ctrl_alt_bksp"),
              repeat_delay: 600,
              repeat_rate: 25,
          )'';
          workspaces = cosmicLib.cosmic.mkRON "raw" ''(
              workspace_layout: Horizontal,
              workspace_mode: OutputBound,
          )'';
          cursor_follows_focus = true;
          focus_follows_cursor = true;
        };
      };
      "com.system76.CosmicTk" = {
        version = 1;
        entries = {
          apply_theme_global = true;
          interface_density = cosmicLib.cosmic.mkRON "raw" "Compact";
          show_minimize = false;
          show_maximize = false;
          header_size = cosmicLib.cosmic.mkRON "raw" "Compact";
          icon_theme = cosmicLib.cosmic.mkRON "raw" ''"Cosmic"'';
        };
      };

      "com.system76.CosmicAppList" = {
        version = 1;
        entries = {
          favorites = cosmicLib.cosmic.mkRON "raw" ''[
          ]'';
          # favorites = cosmicLib.cosmic.mkRON "raw" "[\n    \"firefox\",\n    \"com.system76.CosmicFiles\",\n    \"com.system76.CosmicEdit\",\n    \"com.system76.CosmicStore\",\n    \"kitty\",\n    \"com.system76.CosmicSettings\",\n]";
          filter_top_levels = cosmicLib.cosmic.mkRON "optional" null;
          enable_drag_source = true;
        };
      };

      "com.system76.CosmicBackground" = {
        version = 1;
        entries = {
          backgrounds = cosmicLib.cosmic.mkRON "raw" "[]";
          # all = cosmicLib.cosmic.mkRON "raw" "(\n  output: \"all\",\n  source: Path(\"/nix/store/91dlkl1qn42b6yadadjkl3yr0dbsfdc8-gnome-background-png-1.0/drool-l.png\"),\n  filter_by_theme: false,\n  rotation_frequency: 300,\n  filter_method: Lanczos,\n  scaling_mode: Zoom,\n  sampling_method: Alphanumeric,\n)\n";
          # all = cosmicLib.cosmic.mkRON "raw" ''(
          #   output: "all",
          #   source: Path("${wallpaper.light}"),
          #   filter_by_theme: false,
          #   rotation_frequency: 300,
          #   filter_method: Lanczos,
          #   scaling_mode: Zoom,
          #   sampling_method: Alphanumeric,
          # )
          # '';
          same-on-all = true;
        };
      };
      "com.system76.CosmicSettings.Wallpaper" = {
        version = 1;
        entries = {
          custom-colors = cosmicLib.cosmic.mkRON "raw" "[]";
          custom-images = cosmicLib.cosmic.mkRON "raw" ''[
              "${wallpaper.light}",
              "${wallpaper.dark}",
          ]'';
        };
      };

      "com.system76.CosmicTheme.Mode" = {
        version = 1;
        entries = {
          auto_switch = false;
        };
      };

      "com.system76.CosmicSettings.Shortcuts" = {
        version = 1;
        entries = {
          # custom = cosmicLib.cosmic.mkRON "raw" "{\n    (\n        modifiers: [],\n        key: \"Print\",\n    ): Disable,\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"e\",\n        description: Some(\"files\"),\n    ): Spawn(\"cosmic-files\"),\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"Return\",\n        description: Some(\"kitty\"),\n    ): Spawn(\"kitty\"),\n    (\n        modifiers: [\n            Super,\n            Shift,\n        ],\n        key: \"Right\",\n    ): MoveToNextWorkspace,\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"Down\",\n    ): System(WorkspaceOverview),\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"f\",\n        description: Some(\"firefox\"),\n    ): Spawn(\"firefox\"),\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"Up\",\n    ): System(WorkspaceOverview),\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"Left\",\n    ): PreviousWorkspace,\n    (\n        modifiers: [\n            Super,\n            Shift,\n        ],\n        key: \"Left\",\n    ): MoveToPreviousWorkspace,\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"Right\",\n    ): NextWorkspace,\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"l\",\n    ): System(LockScreen),\n    (\n        modifiers: [\n            Super,\n        ],\n        key: \"w\",\n    ): Close,\n}";
          custom = cosmicLib.cosmic.mkRON "raw" ''{
              (
                  modifiers: [],
                  key: "Print",
              ): Disable,
              (
                  modifiers: [
                      Super,
                  ],
                  key: "e",
                  description: Some("files"),
              ): Spawn("cosmic-files"),
              (
                  modifiers: [
                      Super,
                  ],
                  key: "Return",
                  description: Some("kitty"),
              ): Spawn("kitty"),
              (
                  modifiers: [
                      Super,
                      Shift,
                  ],
                  key: "Right",
              ): MoveToNextWorkspace,
              (
                  modifiers: [
                      Super,
                  ],
                  key: "Down",
              ): System(WorkspaceOverview),
              (
                  modifiers: [
                      Super,
                  ],
                  key: "f",
                  description: Some("firefox"),
              ): Spawn("firefox"),
              (
                  modifiers: [
                      Super,
                  ],
                  key: "Up",
              ): System(WorkspaceOverview),
              (
                  modifiers: [
                      Super,
                  ],
                  key: "Left",
              ): PreviousWorkspace,
              (
                  modifiers: [
                      Super,
                      Shift,
                  ],
                  key: "Left",
              ): MoveToPreviousWorkspace,
              (
                  modifiers: [
                      Super,
                  ],
                  key: "Right",
              ): NextWorkspace,
              (
                  modifiers: [
                      Super,
                  ],
                  key: "l",
              ): System(LockScreen),
              (
                  modifiers: [
                      Super,
                  ],
                  key: "w",
              ): Close,
          }'';
          # system_actions = cosmicLib.cosmic.mkRON "raw" "{\n    Terminal: \"kitty\",\n}";
          system_actions = cosmicLib.cosmic.mkRON "raw" ''{
            Terminal: "kitty",
          }'';
        };
      };

      "com.system76.CosmicPanel" = {
        version = 1;
        entries = {
          entries = cosmicLib.cosmic.mkRON "raw" ''
            [
                "Panel",
                "Dock",
            ]'';

        };
      };

      "com.system76.CosmicPanel.Panel" = {
        version = 1;
        entries = {
          border_radius = 0;
          anchor = cosmicLib.cosmic.mkRON "raw" "Top";
          keyboard_interactivity = cosmicLib.cosmic.mkRON "raw" "OnDemand";
          spacing = 0;
          opacity = 1.0;
          plugins_center = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" ''
            [
              "com.system76.CosmicAppletTime",
            ]'');
          size_center = cosmicLib.cosmic.mkRON "optional" null;
          layer = cosmicLib.cosmic.mkRON "raw" "Top";
          padding = 0;
          output = cosmicLib.cosmic.mkRON "raw" "All";
          margin = 0;
          anchor_gap = false;
          autohover_delay_ms = cosmicLib.cosmic.mkRON "optional" 500;
          size = cosmicLib.cosmic.mkRON "raw" "Custom(24)";
          background = cosmicLib.cosmic.mkRON "raw" "ThemeDefault";
          # autohide = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    wait_time: 1000,\n    transition_time: 200,\n    handle_size: 4,\n    unhide_delay: 200,\n)");
          autohide = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" ''(
              wait_time: 1000,
              transition_time: 200,
              handle_size: 4,
              unhide_delay: 200,
          )'');
          name = cosmicLib.cosmic.mkRON "raw" ''"Panel"'';
          expand_to_edges = true;
          exclusive_zone = false;
          size_wings = cosmicLib.cosmic.mkRON "optional" null;
          # plugins_wings = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "([\n    \"com.system76.CosmicPanelWorkspacesButton\",\n    \"com.system76.CosmicAppletWorkspaces\",\n], [\n    \"com.system76.CosmicAppletStatusArea\",\n    \"com.system76.CosmicAppletTiling\",\n    \"com.system76.CosmicAppletAudio\",\n    \"com.system76.CosmicAppletBluetooth\",\n    \"com.system76.CosmicAppletNetwork\",\n    \"com.system76.CosmicAppletBattery\",\n    \"com.system76.CosmicAppletNotifications\",\n    \"com.system76.CosmicAppletPower\",\n])");
          plugins_wings = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" ''([
              "com.system76.CosmicPanelWorkspacesButton",
              "com.system76.CosmicAppletWorkspaces",
          ], [
              "com.system76.CosmicAppletStatusArea",
              "com.system76.CosmicAppletTiling",
              "com.system76.CosmicAppletAudio",
              "com.system76.CosmicAppletBluetooth",
              "com.system76.CosmicAppletNetwork",
              "com.system76.CosmicAppletBattery",
              "com.system76.CosmicAppletNotifications",
              "com.system76.CosmicAppletPower",
          ])'');
        };
      };

      "com.system76.CosmicPanel.Dock" = {
        version = 1;
        entries = {
          anchor = cosmicLib.cosmic.mkRON "raw" "Bottom";
          anchor_gap = false;
          # autohide = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    wait_time: 500,\n    transition_time: 200,\n    handle_size: 2,\n    unhide_delay: 200,\n)");
          autohide = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" ''(
              wait_time: 500,
              transition_time: 200,
              handle_size: 2,
              unhide_delay: 200,
          )'');
          autohover_delay_ms = cosmicLib.cosmic.mkRON "optional" 500;
          background = cosmicLib.cosmic.mkRON "raw" "ThemeDefault";
          border_radius = 12;
          exclusive_zone = false;
          expand_to_edges = false;
          keyboard_interactivity = cosmicLib.cosmic.mkRON "raw" "OnDemand";
          layer = cosmicLib.cosmic.mkRON "raw" "Top";
          margin = 0;
          name = cosmicLib.cosmic.mkRON "raw" ''"Dock"'';
          opacity = 1.0;
          output = cosmicLib.cosmic.mkRON "raw" "All";
          padding = 0;
          padding_overlap = 0.5;
          # plugins_center = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "[\n    \"com.system76.CosmicPanelWorkspacesButton\",\n    \"com.system76.CosmicPanelAppButton\",\n    \"com.system76.CosmicAppList\",\n    \"com.system76.CosmicAppletMinimize\",\n]");
          plugins_center = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" ''[
              "com.system76.CosmicPanelAppButton",
              "com.system76.CosmicAppList",
              "com.system76.CosmicAppletMinimize",
          ]'');
          plugins_wings = cosmicLib.cosmic.mkRON "optional" null;
          size = cosmicLib.cosmic.mkRON "raw" "S";
          size_center = cosmicLib.cosmic.mkRON "optional" null;
          size_wings = cosmicLib.cosmic.mkRON "optional" null;
          spacing = 0;
        };
      };


      "com.system76.CosmicAppletAudio" = {
        version = 1;
        entries = {
          show_media_controls_in_top_panel = false;
        };
      };
      "com.system76.CosmicAppletTime" = {
        version = 1;
        entries = {
          first_day_of_week = 0;
          military_time = true;
        };
      };
      "com.system76.CosmicFiles" = {
        version = 1;
        entries = {
          # tab = cosmicLib.cosmic.mkRON "raw" "(\n    folders_first: true,\n    icon_sizes: (\n        list: 100,\n        grid: 100,\n    ),\n    show_hidden: true,\n    single_click: false,\n    view: List,\n)";
          tab = cosmicLib.cosmic.mkRON "raw" ''(
              folders_first: true,
              icon_sizes: (
                  list: 100,
                  grid: 100,
              ),
              show_hidden: true,
              single_click: false,
              view: List,
          )'';
          # desktop = cosmicLib.cosmic.mkRON "raw" "(\n    grid_spacing: 100,\n    icon_size: 100,\n    show_content: false,\n    show_mounted_drives: false,\n    show_trash: false,\n)";
          desktop = cosmicLib.cosmic.mkRON "raw" ''(
              grid_spacing: 100,
              icon_size: 100,
              show_content: false,
              show_mounted_drives: false,
              show_trash: false,
          )'';
          show_details = false;
        };
      };
      "com.system76.CosmicPanelButton" = {
        version = 1;
        entries = {
          # configs = cosmicLib.cosmic.mkRON "raw" "{\n    \"Dock\": (\n        force_presentation: Some(Icon),\n    ),\n    \"Panel\": (\n        force_presentation: None,\n    ),\n}";
          configs = cosmicLib.cosmic.mkRON "raw" ''{
              "Dock": (
                  force_presentation: Some(Icon),
              ),
              "Panel": (
                  force_presentation: None,
              ),
          }'';
        };
      };
      "com.system76.CosmicNotifications" = {
        version = 1;
        entries = {
          do_not_disturb = false;
          anchor = cosmicLib.cosmic.mkRON "raw" "Top";
          max_notifications = 3;
          max_timeout_urgent = cosmicLib.cosmic.mkRON "optional" null;
          max_timeout_normal = cosmicLib.cosmic.mkRON "optional" 5000;
          max_timeout_low = cosmicLib.cosmic.mkRON "optional" 3000;
          max_per_app = 2;
        };
      };
    };
  };
}

