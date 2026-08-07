{ pkgs
, wallpaper
, lib
, ...
}:
{

  services.xserver.enable = lib.mkDefault true;

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
    theme = "chili";
  };
}
