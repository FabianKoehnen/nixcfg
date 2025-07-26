{ user
, unstable
, lib
, ...
}: {
  services.ollama = {
    enable = true;
  };

  home-manager.users.${user} = {
    catppuccin.zed = {
      enable = true;
      accent = "red";
    };
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      package = unstable.zed-editor;
      # themes = {
      #   path = ./themes/GitLab_Light.json;
      # };
      extensions = [
        "nix"
        "php"
        "html"
        "toml"
        "gdscript"
        # "intellij-newui-theme"
        # "jetbrains-new-ui-icons"
        # "material-icon-theme"
      ];

      userSettings = {
        ssh_connections = [
          {
            host = "halbgar.xyz";
            projects = [
              {
                paths = [ "/etc/nixos" ];
              }
            ];
          }
          {
            host = "fabian-nas";
            projects = [
              {
                paths = [ "/etc/nixos" ];
              }
            ];
          }
          {
            host = "fabians-nix-backup";
            projects = [
              {
                paths = [ "/etc/nixos" ];
              }
            ];
          }
        ];
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
          # light = "GitLab Light";
          dark = lib.mkForce "Catppuccin Mocha (red)";
        };

        icon_theme = {
          mode = "system";
          light = "Material Icon Theme";
          dark = "Material Icon Theme";
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
            model = "qwen3:30b-a3b";
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
  };
}
