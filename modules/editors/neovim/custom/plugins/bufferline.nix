{ user, ... }:
{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  home-manager.users.${user}.programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      settings = {
        options.offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
        ];
      };
    };
  };
}
