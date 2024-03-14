{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nil
  ];

  home-manager.users.${user}.programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions;
      [
        rust-lang.rust-analyzer
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        antyos.openscad
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
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
          name = "vscode-jetbrains-icon-theme";
          publisher = "chadalen";
          version = "2.15.0";
          sha256 = "sha256-c2akqxYyoSLuEVaVOOKdkO3GDauUZ4bhL/NdZoiRSAY=";
        }
        {
          name = "webstorm-new-dark";
          publisher = "eenaree";
          version = "2.6.2";
          sha256 = "sha256-LKpDAc8XaaeLU8GFmPoZoFAMcGin1o+4pmKvyFCjljE=";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          version = "2024.3.1405";
          sha256 = "sha256-7ILcHH3JrhN/mgXVaXGawYa4XdjqPyXO8y4hLbOzLQs=";
        }
      ];
    keybindings = let
      darwinSystem = pkgs.system == "x86_64-darwin";

      linux-mod1 = "ctrl";
      darwin-mod1 = "cmd";

      mod1 =
        if darwinSystem
        then darwin-mod1
        else linux-mod1;
    in [
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
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "terminal.external.linuxExec" = "kitty";
      "workbench.iconTheme" = "vscode-jetbrains-icon-theme-2023-auto";
      "workbench.colorTheme" = "Webstorm New Light";
    };
  };
}
