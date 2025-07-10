{ user, pkgs, config, ... }: {
  home-manager.users.${user} = {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      keybindings = {
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+c" = "copy_to_clipboard";
      };
      themeFile = "CLRS";
      settings = {
        enable_audio_bell = false;
        shell_integration = "disabled";
        visual_bell_duration = "0.6 ease";
        visual_bell_color = "MidnightBlue";
      };
    };

    xdg.configFile."kitty/light-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/CLRS.conf";
    xdg.configFile."kitty/dark-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/Argonaut.conf";
  };
}
