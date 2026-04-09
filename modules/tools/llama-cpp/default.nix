{ pkgs }: {
  services = {
    llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp.override { cudaSupport = true; };
      port = 1234;
      openFirewall = true;
    };
    # llama-swap = {
    #   enable = true;
    # };
  };
}
