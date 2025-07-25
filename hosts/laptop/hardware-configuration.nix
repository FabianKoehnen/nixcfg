# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6C21-1432";
    fsType = "vfat";
  };

  fileSystems."/btrfs-root" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/var/lib" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=var/lib" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=var/log" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/etc/nixos" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=nixos-config" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/nix-build" = {
    device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
    fsType = "btrfs";
    options = [ "subvol=nix-build" ];
  };
  # fileSystems."/tmp" =
  # { device = "/dev/disk/by-uuid/708acdeb-4819-46a3-a8e6-18d32816ecea";
  #   fsType = "btrfs";
  #   options = [ "subvol=big-tmp" ];
  # };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
