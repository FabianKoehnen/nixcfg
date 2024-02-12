{ user, ...}:
{
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${user} = {
      home = {
        stateVersion = "23.05";
        username = user;
        homeDirectory = "/Users/${user}";
      };


      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.zsh = {
        enable = true;
      };
    };
}
