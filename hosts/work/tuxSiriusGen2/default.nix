# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ config
, pkgs
, unstable
, user
, ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../../modules/base/nix-ld.nix
    ../../../modules/base/bin-bash-fix.nix
    ../../../modules/hardware/tuxedo
    ../../../modules/hardware/logitech/mxmaster
    ../../modules/hardware/headsetcontrol


    ../../../modules/tools/plymouth

    ../../../modules/tools/darkman

    # ../../../modules/tools/sddm
    ../../../modules/tools/cosmic-greet
    ../../../modules/desktops/hyprland
    # ../../../modules/desktops/cosmic


    ../../../modules/terminal/zsh
    ../../../modules/terminal/kitty

    ../../../modules/editors/jetbrains
    ../../../modules/editors/vscodium

    ../../../modules/dev/ambimax
  ];


  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        configurationLimit = 50;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "tuxSiriusGen2-fk";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "de";
    #   useXkbConfig = true; # use xkbOptions in tty.
  };
  services.xserver.xkb.layout = "de";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [
    pkgs.gutenprint
    pkgs.hplipWithPlugin
    # pkgs.samsung-unified-linux-driver
    pkgs.brlaser
    pkgs.brgenml1lpr
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true;

  # Trim SSDs periodicly
  services.fstrim.enable = true;

  services.flatpak.enable = true;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    util-linux
    wget
    killall
    gparted
    parted
    unzip
    zip
    git
    powertop
    nvtopPackages.amd
    docker-compose
    sops
    symfony-cli
    spotify
    unstable.youtube-music
    slack
    kubectl

    comma

    firefox
    ungoogled-chromium
    vivaldi

    polonium
    system-config-printer
  ];

  services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  services.languagetool.enable = true;

  services.flatpak = {
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    uninstallUnmanaged = true;
    packages = [
      "com.github.dynobo.normcap"
    ];
  };


  environment.persistence."/persist/impermanence" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  virtualisation.docker = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  users = {
    mutableUsers = false;
    users.fabian = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };

  programs.git = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  services.yubikey-agent.enable = true;

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      systemd-udev-settle.enable = false;
    };
  };

  services.ratbagd.enable = true;

  services.udev = {
    enable = true;
    extraRules = ''
      # SteelSeries Arctis Nova 7
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="2202", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="2206", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="220a", TAG+="uaccess"
    '';
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  powerManagement.powertop.enable = true;
  #  systemd.sleep.extraConfig = ''
  #    AllowSuspend=no
  #    AllowHibernation=no
  #    AllowHybridSleep=no
  #    AllowSuspendThenHibernate=no
  #  '';
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 50;

  #     #Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 70; # 70 and bellow it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  environment.etc.hosts.mode = "0644";

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  #services.nginx.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
