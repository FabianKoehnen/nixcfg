{ pkgs, ... }:
let
  godot_latest_overlay = self: super: {
    godot_latest = super.godot_4.overrideAttrs (oldAttrs: rec {
      version = "latest";
      src = super.fetchFromGitHub {
        owner = "godotengine";
        repo = "godot";
        rev = "15ff450680a40391aabbffde0a57ead2cd84db56"; # Replace with the correct commit hash
        sha256 = "En5CaCogjgYizb0mOXR35AgvPJgXUm032ehdVSH7pSc="; # Replace with the correct SHA-256 hash
      };
      meta = oldAttrs.meta // {
        name = "Godot ${version}"; # Set a new name
        description = "Godot Engine ${version} - Advanced 2D and 3D open-source game engine";
      };

      # Modify the .desktop file at the correct location
      postFixup = oldAttrs.postFixup or "" + ''
        desktopDir="$out/share/applications"
        desktopFile=$(find "$desktopDir" -name "org.godotengine.Godot4*.desktop" | head -n 1)

        if [ -f "$desktopFile" ]; then
          echo "Updating .desktop file: $desktopFile"
          sed -i 's/^Name=.*/Name=Godot-${version}/' "$desktopFile"
        else
          echo "Warning: No matching .desktop file found in $desktopDir"
        fi
      '';
    });
  };


in
{
  # nixpkgs.overlays = [
  #   godot_latest_overlay
  # ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "dotnet-sdk-6.0.428"
  # ];
  environment.systemPackages = with pkgs;[
    jetbrains.rider
    # godot_4-mono
    # dotnetCorePackages.dotnet_9.sdk

    # godot_latest
  ];
}
