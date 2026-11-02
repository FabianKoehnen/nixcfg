{ lib, user, ... }: {
  home-manager.users.${user} = {
    programs.yazi = {
      enable = true;
      shellWrapperName = lib.mkDefault "y";
    };
    home.file.".config/yazi/keymap.toml".source = ./keymap.toml;
  };
}
