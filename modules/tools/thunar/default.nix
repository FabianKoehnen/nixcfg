{ pkgs, ... }: {
  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.thunar-media-tags-plugin
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    pkgs.adwaita-icon-theme

    # https://wiki.archlinux.org/title/File_manager_functionality
    webp-pixbuf-loader # webp preview
    poppler # pdf preview
    ffmpegthumbnailer # ffmpeg thumbnails
    libgsf # .odf file preview
    gnome-epub-thumbnailer # epub and .mobi ebook
    f3d # 3D files
  ];
}
