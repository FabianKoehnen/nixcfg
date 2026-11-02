{ pkgs
, unstable
, ...
}: {
  imports = [ ./cosmic.nix ];
  config = {
    xdg = {
      enable = true;
      portal.xdgOpenUsePortal = true;
    };
    home = {
      stateVersion = "23.11";
      packages = with pkgs; [
        unstable.piper
        signal-desktop
        # discord
      ];
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
