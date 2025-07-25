{ pkgs
, user
, unstable
, ...
}: {
  environment.systemPackages = with pkgs; [
    nil
    unstable.nixd
  ];

  home-manager.users.${user} = {
    catppuccin = {
      flavor = "latte";
      vscode = {
        profiles.default = {
          enable = true;
          accent = "red";
        };
      };
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions;
          [
            rust-lang.rust-analyzer
            golang.go
            jnoortheen.nix-ide
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh
            xdebug.php-debug
            antyos.openscad
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "yuck";
              publisher = "eww-yuck";
              version = "0.0.3";
              sha256 = "sha256-DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM=";
            }
            {
              name = "direnv";
              publisher = "mkhl";
              version = "0.16.0";
              sha256 = "sha256-u2AFjvhm3zio1ygW9yD9ZwbywLrEssd0O7/0AtfCvMo=";
            }
            {
              name = "godot-tools";
              publisher = "geequlim";
              version = "2.5.1";
              sha256 = "sha256-kAzRSNZw1zaECblJv7NzXnE2JXSy9hzdT2cGX+uwleY=";
            }
          ];

        keybindings =
          let
            darwinSystem = pkgs.system == "x86_64-darwin";

            linux-mod1 = "ctrl";
            darwin-mod1 = "cmd";

            mod1 =
              if darwinSystem
              then darwin-mod1
              else linux-mod1;
          in
          [
            {
              key = "${mod1}+-";
              command = "-workbench.action.zoomOut";
            }
            {
              key = "${mod1}+k ${mod1}+c";
              command = "-editor.action.addCommentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "${mod1}+-";
              command = "editor.action.commentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "${mod1}+shift+7";
              command = "-editor.action.commentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "${mod1}+d";
              command = "-editor.action.addSelectionToNextFindMatch";
              when = "editorFocus";
            }
            {
              key = "${mod1}+d";
              command = "editor.action.duplicateSelection";
            }

            # Terminal
            {
              key = "${mod1}+c";
              command = "workbench.action.terminal.copySelection";
              when = "terminalTextSelectedInFocused || terminalFocus && terminalHasBeenCreated && terminalTextSelected || terminalFocus && terminalProcessSupported && terminalTextSelected || terminalFocus && terminalTextSelected && terminalTextSelectedInFocused || terminalHasBeenCreated && terminalTextSelected && terminalTextSelectedInFocused || terminalProcessSupported && terminalTextSelected && terminalTextSelectedInFocused";
            }
            {
              key = "${mod1}+v";
              command = "workbench.action.terminal.paste";
              when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
            }
          ];
        userSettings = {
          "editor.emptySelectionClipboard" = false;
          "editor.formatOnSave" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
          "terminal.external.linuxExec" = "kitty";
          "window.autoDetectColorScheme" = true;
          "window.autoDetectHighContrast" = false;
          "workbench.preferredLightColorTheme" = "Catppuccin Latte";
          "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
        };
      };
    };
  };
}
