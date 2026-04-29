{ pkgs
, lib
, ...
}: {
  imports = [
    ./localisation.nix
    ./nix.nix
    ./terminal.nix
    ./flatpak.nix

    ../../modules/tools/plymouth
    ../../modules/base/fonts.nix
    ../../modules/base/printing.nix

    ../../modules/hardware/headsetcontrol
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ZRAM swap with zstd
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
  };

  systemd.coredump.enable = false;

  services = {
    fwupd.enable = lib.mkDefault true;
    earlyoom.enable = lib.mkDefault true;
    libinput.enable = true;

    # Trim SSDs weekly (harmless on HDDs)
    fstrim = {
      enable = lib.mkDefault true;
      interval = lib.mkDefault "weekly";
    };
    smartd = {
      enable = lib.mkDefault true;
      notifications = {
        x11.enable = lib.mkDefault true;
        test = true;
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  security.polkit.enable = lib.mkDefault true;

  networking = {
    networkmanager.enable = lib.mkDefault true;
    wireless.userControlled = true;
  };

  hardware = {
    bluetooth.enable = lib.mkDefault true; # enables support for Bluetooth
    bluetooth.powerOnBoot = lib.mkDefault true; # powers up the default Bluetooth controller on boot
  };

  virtualisation.docker.enable = true;

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      systemd-udev-settle.enable = false;
    };
  };
}
