{ pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
  ];
  environment.systemPackages = with pkgs;[
    jetbrains.rider
    godot_4-mono
    dotnetCorePackages.dotnet_9.sdk
  ];
}
