{ user
, lib
, ...
}: {
  home-manager.users.${user} = {
    programs.git = {
      enable = lib.mkDefault true;
      settings = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = lib.mkDefault "fabianKoehnen";
          email = lib.mkDefault "2826098-fabianKoehnen@users.noreply.gitlab.com";
        };
      };
    };
  };
}
