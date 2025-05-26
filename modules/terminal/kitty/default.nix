{ user, pkgs, config, ... }: {
  home-manager.users.${user}.programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    keybindings = {
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+c" = "copy_to_clipboard";
    };
    themeFile = "CLRS";
    settings = {
      enable_audio_bell = false;
      visual_bell_duration = "0.6 ease";
      visual_bell_color = "MidnightBlue";
    };
  };
}
