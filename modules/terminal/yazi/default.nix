{ user, ... }: {
  home-manager.users.${user} = {
    programs.yazi = {
      enable = true;
    };
    home.file.".config/yazi/keymap.toml".source = ./keymap.toml;
  };
}
