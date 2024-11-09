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

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9411-24B3";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=var/log" ];
  };

  fileSystems."/var/lib/tailscale" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=var/lib/tailscale" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/etc/nixos" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=nixos-config" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };  
  
  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
    options = [ "subvol=big-tmp" ];
  };

  fileSystems."/btrfs-root" = {
    device = "/dev/disk/by-uuid/13f36515-109e-441b-8522-4a1ebfed4459";
    fsType = "btrfs";
  };

  fileSystems."/LinuxData" = {
    device = "/dev/disk/by-uuid/18d5f748-4178-4364-97fe-1f8b57d0c307";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
