{ user, ... }: {
  home-manager.users.${user}.programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    keybindings = {
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+c" = "copy_to_clipboard";
    };
  };
}
