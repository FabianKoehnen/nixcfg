{ user
, lib
, ...
}: {
  home-manager.users.${user} = {
    programs.git = {
      enable = lib.mkDefault true;
      userName = lib.mkDefault "fabianKoehnen";
      userEmail = lib.mkDefault "2826098-fabianKoehnen@users.noreply.gitlab.com";
      settings = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
