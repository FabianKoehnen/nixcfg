{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  hardware = {
    #    tuxedo-keyboard.enable = true;
    #    tuxedo-rs = {
    #      enable = true;
    #      tailor-gui.enable = true;
    #    };
  };

  boot.kernelParams = lib.mkDefault [
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.brightness=100"
    "tuxedo_keyboard.color_left=0xff4000"
  ];
}
