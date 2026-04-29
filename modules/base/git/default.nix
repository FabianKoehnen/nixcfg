{ user
, lib
, ...
}: {
  home-manager.users.${user} = {
    programs.git = {
      enable = lib.mkDefault true;
      signing.format = null;
      settings = {
        user = {
          name = lib.mkDefault "fabianKoehnen";
          email = lib.mkDefault "42027473+FabianKoehnen@users.noreply.github.com";
        };
      };
    };
  };
}
