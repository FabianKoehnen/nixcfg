{ pkgs, ... }:
{
    programs.thunar.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    environment.systemPackages = with pkgs; [
        xfce.thunar-media-tags-plugin
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        gnome.adwaita-icon-theme
#        webp-pixbuf-loader
#        poppler
#        ffmpegthumbnailer
#        libgsf
#        gnome-epub-thumbnailer
#        f3d
    ];
}