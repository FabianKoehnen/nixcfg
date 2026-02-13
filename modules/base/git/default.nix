{ user
, lib
, ...
}: {
  home-manager.users.${user} = {
    programs.git = {
      enable = lib.mkDefault true;
      userName = lib.mkDefault "fabianKoehnen";
      userEmail = lib.mkDefault "42027473+FabianKoehnen@users.noreply.github.com";
      settings = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
