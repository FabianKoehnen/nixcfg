{ user
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    viu
  ];
  home-manager.users.${user}.programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "dark:0x96f,light:CLRS";
      copy-on-select = false;
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };
}
