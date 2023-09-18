{ pkgs, ... }:
{
    programs.thunar.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    environment.systemPackages = with pkgs; [
#        webp-pixbuf-loader
#        poppler
#        ffmpegthumbnailer
#        libgsf
#        gnome-epub-thumbnailer
#        f3d
    ];
}