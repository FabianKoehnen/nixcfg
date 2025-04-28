{ ... }: {
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [
      "fabian"
    ];
  };
}
