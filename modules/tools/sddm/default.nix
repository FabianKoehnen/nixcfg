{ pkgs, user, wallpaper, ...}:

{
    environment.systemPackages = with pkgs; [
        (sddm-chili-theme.override {
            themeConfig = {
                background="${wallpaper}";
            };
        })
    ];

    

    services.xserver.displayManager.sddm = {
        enable = true;
        theme = "chili";
    };
}