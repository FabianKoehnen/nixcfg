{ pkgs
, wallpaper
, ...
}: {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = "${wallpaper.light}";
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland = {
      enable = false;
      # compositor = "weston";
    };
    # theme = "chili";
  };
}
