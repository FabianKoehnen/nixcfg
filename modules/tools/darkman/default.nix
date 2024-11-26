{ user, ... }: {
  home-manager.users.${user}.services.darkman = {
    enable = true;
    settings = {
      lat = 49.0;
      lng = 7.0;
      usegeoclue = false;
      dbusserver = true;
      portal = true;
    };
  };
}
