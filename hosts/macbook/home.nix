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
    };
}
