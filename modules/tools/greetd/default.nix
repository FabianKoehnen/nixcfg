{ ...
}: {
  services.greetd = {
    enable = true;
    #    settings = {
    #      initial_session = {
    #        command = "${pkgs.hyprland}/bin/Hyprland";
    #        user = "fabian";
    #      };
    #    };

    #   restart = false;
    #   settings = {
    #     default_session = {
    #       command = ''

    #       '';
    #     };
    #   };
  };

  programs.regreet = {
    enable = true;
    cageArgs = [ "-s" ];
  };
}
