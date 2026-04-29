{ user, ... }: {
  home-manager.users.${user} = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    home.file.".config/yazi/keymap.toml".source = ./keymap.toml;
  };
}
