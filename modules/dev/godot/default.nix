{ pkgs, ... }: {
  packages = with pkgs;[
    jetbrains.rider
    godot_4-mono
  ];
}
