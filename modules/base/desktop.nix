{ pkgs
, lib
, ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Trim SSDs weekly (harmless on HDDs)
  services.fstrim = {
    enable = lib.mkDefault true;
    interval = lib.mkDefault "weekly";
  };

  # ZRAM swap with zstd
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;
  # Nix store optimizations and GC
  nix.settings.auto-optimise-store = lib.mkDefault true;
  nix.settings.experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  # Power management defaults
  powerManagement = {
    enable = lib.mkDefault true;
    cpuFreqGovernor = lib.mkDefault "performance";
  };
  services.fwupd.enable = lib.mkDefault true;

  security.polkit.enable = lib.mkDefault true;

  services.earlyoom.enable = lib.mkDefault true;


  networking.networkmanager.enable = lib.mkDefault true;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    #   useXkbConfig = true; # use xkbOptions in tty.
  };
  services.xserver.xkb.layout = lib.mkDefault "eu";


  hardware.bluetooth.enable = lib.mkDefault true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = lib.mkDefault true; # powers up the default Bluetooth controller on boot

}
