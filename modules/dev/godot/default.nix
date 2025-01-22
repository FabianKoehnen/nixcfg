{ pkgs, ... }: {
  environment.systemPackages = with pkgs;[
    jetbrains.rider
    godot_4-mono
  ];
}
