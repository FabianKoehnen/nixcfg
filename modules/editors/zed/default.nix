{ user, ... }: {

  services.ollama = {
    enable = true;
  };

  home-manager.users.${user}.programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "php"
      "html"
    ];

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      base_keymap = "JetBrains";

      ui_font_size = 16;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "One Dark";
      };

      vim_mode = true;
      vim = {
        use_system_clipboard = "on_yank";
        toggle_relative_line_numbers = true;
      };

      load_direnv = "direct";

      assistant = {
        default_model = {
          provider = "ollama";
          model = "mistral:latest";
        };
        version = "2";
      };

      autosave = "on_focus_change";
      restore_on_startup = "last_workspace";
      tabs = {
        git_status = true;
        file_icons = true;
        collaboration_panel = {
          dock = "right";
        };
      };

      terminal = {
        dock = "bottom";

      };
    };
  };
}
