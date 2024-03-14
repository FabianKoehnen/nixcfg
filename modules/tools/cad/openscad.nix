{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openscad
  ];

  home-manager.users.${user}.home = {
    file = {
      ".local/share/OpenSCAD/libraries/BOSL2" = {
        source = pkgs.fetchFromGitHub {
          owner = "BelfrySCAD";
          repo = "BOSL2";
          rev = "c0e87ad0ce3ce012fb1ebdc8cbfad9c3efeec2c8";
          sha256 = "sha256-EG6WcmtIxXA5/1q7HhEENsDZRBnSBjZUGvy35ZAweJc=";
        };
      };
    };
  };
}
