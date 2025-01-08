{ pkgs, user, ... }: {
  imports = [
    ./kickstart
    ./custom
  ];


  fonts.packages = with pkgs; [ nerdfonts ];

  home-manager.users.${user}.programs.nixvim = {
    colorschemes = {
      one = {
        enable = true;
      };
    };

    opts = {
      background = "light";
      relativenumber = true;
    };

    plugins = {
      direnv.enable = true;
      vim-be-good.enable = true;
      neoscroll.enable = true;
      toggleterm.enable = true;
      multicursors.enable = true;
      hardtime.enable = true;
    };
  };
}