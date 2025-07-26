{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "gnome-background-png";
  version = "1.0";

  nativeBuildInputs = [ pkgs.librsvg ];
  src = pkgs.gnome-backgrounds;

  buildPhase = ''
    mkdir -p $out
    rsvg-convert -w 3840 -h 2160 "$src/share/backgrounds/gnome/drool-l.svg" -o "$out/drool-l.png"
    rsvg-convert -w 3840 -h 2160 "$src/share/backgrounds/gnome/drool-d.svg" -o "$out/drool-d.png"
  '';

  installPhase = "true";
}
