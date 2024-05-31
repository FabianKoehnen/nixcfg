{ pkgs
, wallpaper
, ...
}: {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = "${wallpaper}";
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
  };
}
