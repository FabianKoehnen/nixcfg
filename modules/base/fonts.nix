{ pkgs
, ...
}: {
  fonts.packages = with pkgs; [
    inter
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.ubuntu
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-color-emoji
    ubuntu-classic
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
