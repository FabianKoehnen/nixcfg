{ pkgs, user, ... }:

{

  environment.systemPackages = with pkgs; [
    nixd
  ];

  home-manager.users.${user}.programs.vscode = {
    enable=true;
    package=pkgs.vscodium;
    extensions = with pkgs.vscode-extensions;  [
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      antyos.openscad
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
    ];
    keybindings = [
      {
        key = "ctrl+-";
        command = "-workbench.action.zoomOut";
      }
      {
        key = "ctrl+k ctrl+c";
        command = "-editor.action.addCommentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+-";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+shift+7";
        command = "-editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+d";
        command = "-editor.action.addSelectionToNextFindMatch";
        when = "editorFocus";
      }
      {
        key = "ctrl+d";
        command = "editor.action.duplicateSelection";
      }
    ];
  };
}
