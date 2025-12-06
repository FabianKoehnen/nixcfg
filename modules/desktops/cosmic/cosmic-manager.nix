{ cosmicLib, wallpaper, ... }:
{
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
          all = cosmicLib.cosmic.mkRON "raw" ''(
            output: "all",
            source: Path("${wallpaper.light}"),
            filter_by_theme: false,
            rotation_frequency: 300,
            filter_method: Lanczos,
            scaling_mode: Zoom,
            sampling_method: Alphanumeric,
          )
          '';
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

      "com.system76.CosmicTheme.Dark" = {
        version = 1;
        entries = {
          is_dark = true;
          destructive_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.87144005,\n        green: 0.5828126,\n        blue: 0.5796754,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.53913057,\n        green: 0.35873836,\n        blue: 0.3567776,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.87144005,\n        green: 0.5828126,\n        blue: 0.5796754,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.012920042,\n        green: 0.012919988,\n        blue: 0.012919998,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 0.5,\n    ),\n)";
          accent_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.5080944,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.31203952,\n        green: 0.04305209,\n        blue: 0.043052103,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.5080944,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.012920042,\n        green: 0.012919988,\n        blue: 0.012919998,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          spacing = cosmicLib.cosmic.mkRON "raw" "(\n    space_none: 0,\n    space_xxxs: 4,\n    space_xxs: 4,\n    space_xs: 8,\n    space_s: 8,\n    space_m: 16,\n    space_l: 24,\n    space_xl: 32,\n    space_xxl: 48,\n    space_xxxl: 64,\n)";
          corner_radii = cosmicLib.cosmic.mkRON "raw" "(\n    radius_0: (0.0, 0.0, 0.0, 0.0),\n    radius_xs: (4.0, 4.0, 4.0, 4.0),\n    radius_s: (8.0, 8.0, 8.0, 8.0),\n    radius_m: (16.0, 16.0, 16.0, 16.0),\n    radius_l: (32.0, 32.0, 32.0, 32.0),\n    radius_xl: (160.0, 160.0, 160.0, 160.0),\n)";
          destructive = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.87144005,\n        green: 0.5828126,\n        blue: 0.5796754,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.53913057,\n        green: 0.35873836,\n        blue: 0.3567776,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.87144005,\n        green: 0.5828126,\n        blue: 0.5796754,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.49607843,\n        green: 0.3156863,\n        blue: 0.3137255,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 0.5,\n    ),\n)";
          success_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.53575385,\n        green: 0.72712636,\n        blue: 0.5671264,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.3293267,\n        green: 0.44893444,\n        blue: 0.34893447,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.53575385,\n        green: 0.72712636,\n        blue: 0.5671264,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.012920042,\n        green: 0.012919988,\n        blue: 0.012919998,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 0.5,\n    ),\n)";
          secondary = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.21414194,\n        green: 0.07575699,\n        blue: 0.05831854,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.24685553,\n            green: 0.10502558,\n            blue: 0.08594363,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.32216996,\n            green: 0.194523,\n            blue: 0.17734927,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.39748442,\n            green: 0.28402045,\n            blue: 0.2687549,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.32216996,\n            green: 0.194523,\n            blue: 0.17734927,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.97342616,\n            green: 0.97342616,\n            blue: 0.97342604,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.97342616,\n            green: 0.97342616,\n            blue: 0.97342604,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.24685553,\n            green: 0.10502558,\n            blue: 0.08594363,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.97342616,\n            green: 0.97342616,\n            blue: 0.97342604,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.358078,\n        green: 0.24737006,\n        blue: 0.2334193,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.9338223,\n        green: 0.9338224,\n        blue: 0.9338223,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.17235586,\n        green: 0.17235571,\n        blue: 0.17235574,\n        alpha: 0.25,\n    ),\n)";
          success = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.53575385,\n        green: 0.72712636,\n        blue: 0.5671264,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.3293267,\n        green: 0.44893444,\n        blue: 0.34893447,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.53575385,\n        green: 0.72712636,\n        blue: 0.5671264,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.28627452,\n        green: 0.40588236,\n        blue: 0.30588236,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 0.5,\n    ),\n)";
          text_tint = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.90759414,\n    green: 0.9075942,\n    blue: 0.90759414,\n)");
          accent = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.5080944,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.31203952,\n        green: 0.04305209,\n        blue: 0.043052103,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.5080944,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.26898736,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          icon_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    pressed: (\n        red: 0.086104326,\n        green: 0.08610418,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n    selected: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n)";
          shade = cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.0,\n    green: 0.0,\n    blue: 0.0,\n    alpha: 0.32,\n)";
          warning_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.85261655,\n        green: 0.7804597,\n        blue: 0.38516554,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.52736586,\n        green: 0.48226777,\n        blue: 0.23520897,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.85261655,\n        green: 0.7804597,\n        blue: 0.38516554,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 0.5,\n    ),\n)";
          warning = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.85261655,\n        green: 0.7804597,\n        blue: 0.38516554,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.52736586,\n        green: 0.48226777,\n        blue: 0.23520897,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.85261655,\n        green: 0.7804597,\n        blue: 0.38516554,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.48431373,\n        green: 0.4392157,\n        blue: 0.19215687,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 0.5,\n    ),\n)";
          gaps = cosmicLib.cosmic.mkRON "raw" "(0, 3)";
          button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.6204994,\n        green: 0.62049943,\n        blue: 0.62049943,\n        alpha: 0.25,\n    ),\n    hover: (\n        red: 0.38796425,\n        green: 0.38796428,\n        blue: 0.38796428,\n        alpha: 0.4,\n    ),\n    pressed: (\n        red: 0.16715203,\n        green: 0.16715197,\n        blue: 0.16715199,\n        alpha: 0.625,\n    ),\n    selected: (\n        red: 0.38796425,\n        green: 0.38796428,\n        blue: 0.38796428,\n        alpha: 0.4,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.90759414,\n        green: 0.9075942,\n        blue: 0.90759414,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.90759414,\n        green: 0.9075942,\n        blue: 0.90759414,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.6204994,\n        green: 0.62049943,\n        blue: 0.62049943,\n        alpha: 0.125,\n    ),\n    on_disabled: (\n        red: 0.90759414,\n        green: 0.9075942,\n        blue: 0.90759414,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n)";
          active_hint = 2;
          name = "\"\"cosmic-dark\"\"";
          background = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.10759491,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.19258699,\n            green: 0.056328,\n            blue: 0.040203966,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.27332827,\n            green: 0.15069519,\n            blue: 0.13618356,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.3540696,\n            green: 0.24506238,\n            blue: 0.23216316,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.27332827,\n            green: 0.15069519,\n            blue: 0.13618356,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.90759414,\n            green: 0.9075942,\n            blue: 0.90759414,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.90759414,\n            green: 0.9075942,\n            blue: 0.90759414,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.19258699,\n            green: 0.056328,\n            blue: 0.040203966,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.90759414,\n            green: 0.9075942,\n            blue: 0.90759414,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.2469014,\n        green: 0.16082549,\n        blue: 0.16082548,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.80412734,\n        green: 0.80412745,\n        blue: 0.8041274,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.079014204,\n        green: 0.07901407,\n        blue: 0.0790141,\n        alpha: 0.25,\n    ),\n)";
          palette = cosmicLib.cosmic.mkRON "raw" "(\n    name: \"cosmic-dark\",\n    bright_red: (\n        red: 1.0,\n        green: 0.627451,\n        blue: 0.5647059,\n        alpha: 1.0,\n    ),\n    bright_green: (\n        red: 0.36862746,\n        green: 0.85882354,\n        blue: 0.54901963,\n        alpha: 1.0,\n    ),\n    bright_orange: (\n        red: 1.0,\n        green: 0.6392157,\n        blue: 0.49019608,\n        alpha: 1.0,\n    ),\n    gray_1: (\n        red: 0.105882354,\n        green: 0.105882354,\n        blue: 0.105882354,\n        alpha: 1.0,\n    ),\n    gray_2: (\n        red: 0.14901961,\n        green: 0.14901961,\n        blue: 0.14901961,\n        alpha: 1.0,\n    ),\n    neutral_0: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    neutral_1: (\n        red: 0.105882354,\n        green: 0.105882354,\n        blue: 0.105882354,\n        alpha: 1.0,\n    ),\n    neutral_2: (\n        red: 0.1882353,\n        green: 0.1882353,\n        blue: 0.1882353,\n        alpha: 1.0,\n    ),\n    neutral_3: (\n        red: 0.2784314,\n        green: 0.2784314,\n        blue: 0.2784314,\n        alpha: 1.0,\n    ),\n    neutral_4: (\n        red: 0.36862746,\n        green: 0.36862746,\n        blue: 0.36862746,\n        alpha: 1.0,\n    ),\n    neutral_5: (\n        red: 0.46666667,\n        green: 0.46666667,\n        blue: 0.46666667,\n        alpha: 1.0,\n    ),\n    neutral_6: (\n        red: 0.5686275,\n        green: 0.5686275,\n        blue: 0.5686275,\n        alpha: 1.0,\n    ),\n    neutral_7: (\n        red: 0.67058825,\n        green: 0.67058825,\n        blue: 0.67058825,\n        alpha: 1.0,\n    ),\n    neutral_8: (\n        red: 0.7764706,\n        green: 0.7764706,\n        blue: 0.7764706,\n        alpha: 1.0,\n    ),\n    neutral_9: (\n        red: 0.8862745,\n        green: 0.8862745,\n        blue: 0.8862745,\n        alpha: 1.0,\n    ),\n    neutral_10: (\n        red: 1.0,\n        green: 1.0,\n        blue: 1.0,\n        alpha: 1.0,\n    ),\n    accent_blue: (\n        red: 0.3882353,\n        green: 0.8156863,\n        blue: 0.8745098,\n        alpha: 1.0,\n    ),\n    accent_indigo: (\n        red: 0.6313726,\n        green: 0.7529412,\n        blue: 0.92156863,\n        alpha: 1.0,\n    ),\n    accent_purple: (\n        red: 0.90588236,\n        green: 0.6117647,\n        blue: 0.99607843,\n        alpha: 1.0,\n    ),\n    accent_pink: (\n        red: 1.0,\n        green: 0.6117647,\n        blue: 0.69411767,\n        alpha: 1.0,\n    ),\n    accent_red: (\n        red: 0.99215686,\n        green: 0.6313726,\n        blue: 0.627451,\n        alpha: 1.0,\n    ),\n    accent_orange: (\n        red: 1.0,\n        green: 0.6784314,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    accent_yellow: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    accent_green: (\n        red: 0.57254905,\n        green: 0.8117647,\n        blue: 0.6117647,\n        alpha: 1.0,\n    ),\n    accent_warm_grey: (\n        red: 0.7921569,\n        green: 0.7294118,\n        blue: 0.7058824,\n        alpha: 1.0,\n    ),\n    ext_warm_grey: (\n        red: 0.60784316,\n        green: 0.5568628,\n        blue: 0.5411765,\n        alpha: 1.0,\n    ),\n    ext_orange: (\n        red: 1.0,\n        green: 0.6784314,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    ext_yellow: (\n        red: 0.99607843,\n        green: 0.85882354,\n        blue: 0.2509804,\n        alpha: 1.0,\n    ),\n    ext_blue: (\n        red: 0.28235295,\n        green: 0.7254902,\n        blue: 0.78039217,\n        alpha: 1.0,\n    ),\n    ext_purple: (\n        red: 0.8117647,\n        green: 0.49019608,\n        blue: 1.0,\n        alpha: 1.0,\n    ),\n    ext_pink: (\n        red: 0.9764706,\n        green: 0.22745098,\n        blue: 0.5137255,\n        alpha: 1.0,\n    ),\n    ext_indigo: (\n        red: 0.24313726,\n        green: 0.53333336,\n        blue: 1.0,\n        alpha: 1.0,\n    ),\n)";
          accent_text = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.9466261,\n    green: 0.43986696,\n    blue: 0.37516636,\n    alpha: 1.0,\n)");
          control_tint = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.68987346,\n    green: 0.68987346,\n    blue: 0.68987346,\n)");
          window_hint = cosmicLib.cosmic.mkRON "optional" null;
          primary = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.16063386,\n        green: 0.027909212,\n        blue: 0.01804366,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.2249957,\n            green: 0.08548232,\n            blue: 0.06745846,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.30249614,\n            green: 0.17693408,\n            blue: 0.1607126,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.37999654,\n            green: 0.26838586,\n            blue: 0.25396675,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.30249614,\n            green: 0.17693408,\n            blue: 0.1607126,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 0.5379747,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.946989,\n            green: 0.9469891,\n            blue: 0.946989,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.946989,\n            green: 0.9469891,\n            blue: 0.946989,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.2249957,\n            green: 0.08548232,\n            blue: 0.06745846,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.946989,\n            green: 0.9469891,\n            blue: 0.946989,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.743206,\n            green: 0.74320585,\n            blue: 0.74320585,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.30221096,\n        green: 0.19603123,\n        blue: 0.1881388,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.8685193,\n        green: 0.8685193,\n        blue: 0.8685193,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.124462135,\n        green: 0.12446197,\n        blue: 0.124462,\n        alpha: 0.25,\n    ),\n)";
          is_high_contrast = false;
          text_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    pressed: (\n        red: 0.086104326,\n        green: 0.08610418,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n    selected: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.9466261,\n        green: 0.43986696,\n        blue: 0.37516636,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.9466261,\n        green: 0.43986696,\n        blue: 0.37516636,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.9466261,\n        green: 0.43986696,\n        blue: 0.37516636,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n)";
          link_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    pressed: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    selected: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    selected_text: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 0.5379747,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.9466261,\n        green: 0.43986696,\n        blue: 0.37516636,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.9466261,\n        green: 0.43986696,\n        blue: 0.37516636,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.47331306,\n        green: 0.21993348,\n        blue: 0.18758318,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n)";
          is_frosted = false;
        };
      };

      "com.system76.CosmicTheme.Light" = {
        version = 1;
        entries = {
          button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.1792362,\n        green: 0.1792362,\n        blue: 0.1792362,\n        alpha: 0.25,\n    ),\n    hover: (\n        red: 0.16733268,\n        green: 0.16733268,\n        blue: 0.16733268,\n        alpha: 0.4,\n    ),\n    pressed: (\n        red: 0.40745026,\n        green: 0.40745017,\n        blue: 0.40745017,\n        alpha: 0.625,\n    ),\n    selected: (\n        red: 0.16733268,\n        green: 0.16733268,\n        blue: 0.16733268,\n        alpha: 0.4,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.08788813,\n        green: 0.08788807,\n        blue: 0.08788792,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.08788813,\n        green: 0.08788807,\n        blue: 0.08788792,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.1792362,\n        green: 0.1792362,\n        blue: 0.1792362,\n        alpha: 0.125,\n    ),\n    on_disabled: (\n        red: 0.08788813,\n        green: 0.08788807,\n        blue: 0.08788792,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n)";
          is_frosted = false;
          control_tint = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.7814231,\n    green: 0.7814231,\n    blue: 0.7814231,\n)");
          background = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.9605419,\n        green: 0.9605419,\n        blue: 0.9605419,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.8685193,\n            green: 0.86851937,\n            blue: 0.8685192,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.8816674,\n            green: 0.8816674,\n            blue: 0.88166726,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.89481544,\n            green: 0.8948155,\n            blue: 0.8948153,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.8816674,\n            green: 0.8816674,\n            blue: 0.88166726,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.08788813,\n            green: 0.08788807,\n            blue: 0.08788792,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.08788813,\n            green: 0.08788807,\n            blue: 0.08788792,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.8685193,\n            green: 0.86851937,\n            blue: 0.8685192,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.08788813,\n            green: 0.08788807,\n            blue: 0.08788792,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.79901916,\n        green: 0.7990191,\n        blue: 0.7990191,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.15292823,\n        green: 0.15292805,\n        blue: 0.15292796,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.90759414,\n        green: 0.9075942,\n        blue: 0.90759414,\n        alpha: 0.25,\n    ),\n)";
          corner_radii = cosmicLib.cosmic.mkRON "raw" "(\n    radius_0: (0.0, 0.0, 0.0, 0.0),\n    radius_xs: (4.0, 4.0, 4.0, 4.0),\n    radius_s: (8.0, 8.0, 8.0, 8.0),\n    radius_m: (16.0, 16.0, 16.0, 16.0),\n    radius_l: (32.0, 32.0, 32.0, 32.0),\n    radius_xl: (160.0, 160.0, 160.0, 160.0),\n)";
          window_hint = cosmicLib.cosmic.mkRON "optional" null;
          success_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.15300873,\n        green: 0.34438124,\n        blue: 0.20634198,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.41866195,\n        green: 0.5382696,\n        blue: 0.45199502,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.15300873,\n        green: 0.34438124,\n        blue: 0.20634198,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.8698169,\n        green: 0.86981636,\n        blue: 0.8698163,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.9999997,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.9999997,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 0.5,\n    ),\n)";
          success = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.1530087,\n        green: 0.34438124,\n        blue: 0.20634201,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.41866183,\n        green: 0.5382696,\n        blue: 0.45199507,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.1530087,\n        green: 0.34438124,\n        blue: 0.20634201,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.5470588,\n        green: 0.6666666,\n        blue: 0.5803921,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 0.5,\n    ),\n)";
          destructive = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.45418516,\n        green: 0.20634201,\n        blue: 0.22202832,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.6068971,\n        green: 0.45199507,\n        blue: 0.461799,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.45418516,\n        green: 0.20634201,\n        blue: 0.22202832,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.7352941,\n        green: 0.5803921,\n        blue: 0.5901961,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 0.5,\n    ),\n)";
          gaps = cosmicLib.cosmic.mkRON "raw" "(0, 3)";
          shade = cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.0,\n    green: 0.0,\n    blue: 0.0,\n    alpha: 0.08,\n)";
          link_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    pressed: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    selected: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.6104768,\n        green: 0.0000016244128,\n        blue: 0.0,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.6104768,\n        green: 0.0000016244128,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.3052384,\n        green: 0.0000008122064,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n)";
          active_hint = 2;
          warning = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.33810672,\n        green: 0.30359694,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.53434813,\n        green: 0.5127794,\n        blue: 0.37160292,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.33810672,\n        green: 0.30359694,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.66274506,\n        green: 0.64117646,\n        blue: 0.49999997,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          accent_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.8777146,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.871603,\n        green: 0.37160292,\n        blue: 0.37160292,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.8777146,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.8698165,\n        green: 0.8698164,\n        blue: 0.8698164,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          accent = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.8777146,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.871603,\n        green: 0.37160292,\n        blue: 0.37160292,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.8777146,\n        green: 0.07771457,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 1.0,\n        green: 0.49999997,\n        blue: 0.49999997,\n        alpha: 1.0,\n    ),\n    border: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          palette = cosmicLib.cosmic.mkRON "raw" "(\n    name: \"cosmic-light\",\n    bright_red: (\n        red: 0.5372549,\n        green: 0.01568627,\n        blue: 0.09411765,\n        alpha: 1.0,\n    ),\n    bright_green: (\n        red: 0.0,\n        green: 0.34117648,\n        blue: 0.17254901,\n        alpha: 1.0,\n    ),\n    bright_orange: (\n        red: 0.4745098,\n        green: 0.17254902,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    gray_1: (\n        red: 0.84313726,\n        green: 0.84313726,\n        blue: 0.84313726,\n        alpha: 1.0,\n    ),\n    gray_2: (\n        red: 0.89411765,\n        green: 0.89411765,\n        blue: 0.89411765,\n        alpha: 1.0,\n    ),\n    neutral_0: (\n        red: 1.0,\n        green: 1.0,\n        blue: 1.0,\n        alpha: 1.0,\n    ),\n    neutral_1: (\n        red: 0.87058824,\n        green: 0.87058824,\n        blue: 0.87058824,\n        alpha: 1.0,\n    ),\n    neutral_2: (\n        red: 0.74509805,\n        green: 0.74509805,\n        blue: 0.74509805,\n        alpha: 1.0,\n    ),\n    neutral_3: (\n        red: 0.61960787,\n        green: 0.61960787,\n        blue: 0.61960787,\n        alpha: 1.0,\n    ),\n    neutral_4: (\n        red: 0.50196075,\n        green: 0.50196075,\n        blue: 0.50196075,\n        alpha: 1.0,\n    ),\n    neutral_5: (\n        red: 0.3882353,\n        green: 0.3882353,\n        blue: 0.3882353,\n        alpha: 1.0,\n    ),\n    neutral_6: (\n        red: 0.28235295,\n        green: 0.28235295,\n        blue: 0.28235295,\n        alpha: 1.0,\n    ),\n    neutral_7: (\n        red: 0.18039216,\n        green: 0.18039216,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    neutral_8: (\n        red: 0.08627451,\n        green: 0.08627451,\n        blue: 0.08627451,\n        alpha: 1.0,\n    ),\n    neutral_9: (\n        red: 0.01176471,\n        green: 0.01176471,\n        blue: 0.01176471,\n        alpha: 1.0,\n    ),\n    neutral_10: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    accent_blue: (\n        red: 0.0,\n        green: 0.32156864,\n        blue: 0.3529412,\n        alpha: 1.0,\n    ),\n    accent_indigo: (\n        red: 0.18039216,\n        green: 0.28627452,\n        blue: 0.42745098,\n        alpha: 1.0,\n    ),\n    accent_purple: (\n        red: 0.40784314,\n        green: 0.12941176,\n        blue: 0.4862745,\n        alpha: 1.0,\n    ),\n    accent_pink: (\n        red: 0.5254902,\n        green: 0.01568627,\n        blue: 0.22745098,\n        alpha: 1.0,\n    ),\n    accent_red: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    accent_orange: (\n        red: 0.38431373,\n        green: 0.25098038,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    accent_yellow: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    accent_green: (\n        red: 0.09411765,\n        green: 0.33333334,\n        blue: 0.1607843,\n        alpha: 1.0,\n    ),\n    accent_warm_grey: (\n        red: 0.33333334,\n        green: 0.27843136,\n        blue: 0.25882354,\n        alpha: 1.0,\n    ),\n    ext_warm_grey: (\n        red: 0.60784316,\n        green: 0.5568628,\n        blue: 0.5411765,\n        alpha: 1.0,\n    ),\n    ext_orange: (\n        red: 0.9843137,\n        green: 0.72156864,\n        blue: 0.42352942,\n        alpha: 1.0,\n    ),\n    ext_yellow: (\n        red: 0.96862745,\n        green: 0.8784314,\n        blue: 0.38431373,\n        alpha: 1.0,\n    ),\n    ext_blue: (\n        red: 0.41568628,\n        green: 0.7921569,\n        blue: 0.84705883,\n        alpha: 1.0,\n    ),\n    ext_purple: (\n        red: 0.8352941,\n        green: 0.54901963,\n        blue: 1.0,\n        alpha: 1.0,\n    ),\n    ext_pink: (\n        red: 1.0,\n        green: 0.6117647,\n        blue: 0.8666667,\n        alpha: 1.0,\n    ),\n    ext_indigo: (\n        red: 0.58431375,\n        green: 0.76862746,\n        blue: 0.9882353,\n        alpha: 1.0,\n    ),\n)";
          name = cosmicLib.cosmic.mkRON "raw" ''"cosmic-light"'';
          text_tint = cosmicLib.cosmic.mkRON "optional" null;
          text_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    pressed: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n    selected: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.6104768,\n        green: 0.0000016244128,\n        blue: 0.0,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.6104768,\n        green: 0.0000016244128,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.6104768,\n        green: 0.0000016244128,\n        blue: 0.0,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n)";
          primary = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.90759414,\n        green: 0.9075942,\n        blue: 0.9075941,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.842651,\n            green: 0.842651,\n            blue: 0.84265095,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.8583859,\n            green: 0.8583859,\n            blue: 0.8583858,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.87412083,\n            green: 0.87412083,\n            blue: 0.8741208,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.8583859,\n            green: 0.8583859,\n            blue: 0.8583858,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.07025621,\n            green: 0.07025618,\n            blue: 0.07025603,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.07025621,\n            green: 0.07025618,\n            blue: 0.07025603,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.842651,\n            green: 0.842651,\n            blue: 0.84265095,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.07025621,\n            green: 0.07025618,\n            blue: 0.07025603,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.7491082,\n        green: 0.7491082,\n        blue: 0.74910814,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.11516424,\n        green: 0.11516424,\n        blue: 0.11516408,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.85556674,\n        green: 0.85556674,\n        blue: 0.85556674,\n        alpha: 0.25,\n    ),\n)";
          is_high_contrast = false;
          destructive_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.45418516,\n        green: 0.20634201,\n        blue: 0.22202832,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.6068971,\n        green: 0.45199507,\n        blue: 0.461799,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.45418516,\n        green: 0.20634201,\n        blue: 0.22202832,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.8698165,\n        green: 0.8698164,\n        blue: 0.8698164,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.47058824,\n        green: 0.1607843,\n        blue: 0.18039216,\n        alpha: 0.5,\n    ),\n)";
          spacing = cosmicLib.cosmic.mkRON "raw" "(\n    space_none: 0,\n    space_xxxs: 4,\n    space_xxs: 4,\n    space_xs: 8,\n    space_s: 8,\n    space_m: 16,\n    space_l: 24,\n    space_xl: 32,\n    space_xxl: 48,\n    space_xxxl: 64,\n)";
          secondary = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.842651,\n        green: 0.842651,\n        blue: 0.8426508,\n        alpha: 1.0,\n    ),\n    component: (\n        base: (\n            red: 0.89453316,\n            green: 0.8945333,\n            blue: 0.8945331,\n            alpha: 1.0,\n        ),\n        hover: (\n            red: 0.8050798,\n            green: 0.80507994,\n            blue: 0.80507976,\n            alpha: 1.0,\n        ),\n        pressed: (\n            red: 0.71562654,\n            green: 0.71562666,\n            blue: 0.7156265,\n            alpha: 1.0,\n        ),\n        selected: (\n            red: 0.8050798,\n            green: 0.80507994,\n            blue: 0.80507976,\n            alpha: 1.0,\n        ),\n        selected_text: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        focus: (\n            red: 1.0,\n            green: 0.0,\n            blue: 0.0,\n            alpha: 1.0,\n        ),\n        divider: (\n            red: 0.10596704,\n            green: 0.10596699,\n            blue: 0.10596684,\n            alpha: 0.2,\n        ),\n        on: (\n            red: 0.10596704,\n            green: 0.10596699,\n            blue: 0.10596684,\n            alpha: 1.0,\n        ),\n        disabled: (\n            red: 0.89453316,\n            green: 0.8945333,\n            blue: 0.8945331,\n            alpha: 0.5,\n        ),\n        on_disabled: (\n            red: 0.10596704,\n            green: 0.10596699,\n            blue: 0.10596684,\n            alpha: 0.65,\n        ),\n        border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 1.0,\n        ),\n        disabled_border: (\n            red: 0.08610422,\n            green: 0.08610421,\n            blue: 0.08610421,\n            alpha: 0.5,\n        ),\n    ),\n    divider: (\n        red: 0.6881721,\n        green: 0.6881721,\n        blue: 0.6881718,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.07025621,\n        green: 0.07025618,\n        blue: 0.07025603,\n        alpha: 1.0,\n    ),\n    small_widget: (\n        red: 0.7913618,\n        green: 0.7913618,\n        blue: 0.7913618,\n        alpha: 0.25,\n    ),\n)";
          warning_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    hover: (\n        red: 0.33810672,\n        green: 0.30359694,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    pressed: (\n        red: 0.53434813,\n        green: 0.5127794,\n        blue: 0.37160292,\n        alpha: 1.0,\n    ),\n    selected: (\n        red: 0.33810672,\n        green: 0.30359694,\n        blue: 0.07771457,\n        alpha: 1.0,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    on_disabled: (\n        red: 0.99999994,\n        green: 0.99999994,\n        blue: 0.99999994,\n        alpha: 0.5,\n    ),\n    border: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.3254902,\n        green: 0.28235295,\n        blue: 0.0,\n        alpha: 0.5,\n    ),\n)";
          is_dark = false;
          icon_button = cosmicLib.cosmic.mkRON "raw" "(\n    base: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    hover: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    pressed: (\n        red: 0.743206,\n        green: 0.74320585,\n        blue: 0.74320585,\n        alpha: 0.5,\n    ),\n    selected: (\n        red: 0.38857284,\n        green: 0.38857284,\n        blue: 0.38857284,\n        alpha: 0.2,\n    ),\n    selected_text: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    focus: (\n        red: 1.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 1.0,\n    ),\n    divider: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.2,\n    ),\n    on: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 1.0,\n    ),\n    disabled: (\n        red: 0.0,\n        green: 0.0,\n        blue: 0.0,\n        alpha: 0.0,\n    ),\n    on_disabled: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.65,\n    ),\n    border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 1.0,\n    ),\n    disabled_border: (\n        red: 0.08610422,\n        green: 0.08610421,\n        blue: 0.08610421,\n        alpha: 0.5,\n    ),\n)";
          accent_text = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "raw" "(\n    red: 0.6104768,\n    green: 0.0000016244128,\n    blue: 0.0,\n    alpha: 1.0,\n)");
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
              "com.system76.CosmicPanelWorkspacesButton",
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

