{ user, unstable, ... }: {

  services.ollama = {
    enable = true;
  };

  home-manager.users.${user}.programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    package = unstable.zed-editor;
    themes = {
      path = ./themes/GitLab_Light.json;
    };
    extensions = [
      "nix"
      "php"
      "html"
      "gdscript"
    ];

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      base_keymap = "JetBrains";

      ui_font_size = 16;
      buffer_font_size = 16;
      tab_size = 2;
      theme = {
        mode = "system";
        light = "GitLab Light";
        dark = "JetBrains New Dark";
      };

      icon_theme = {
        mode = "system";
        light = "JetBrains New UI Icons (Light)";
        dark = "JetBrains New UI Icons (Dark)";
      };

      vim_mode = false;
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
        copy_on_select = false;
      };

      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Terminal";
        bindings = {
          ctrl-c = "terminal::Copy";
          ctrl-v = "terminal::Paste";
        };
      }
    ];
  };
}
