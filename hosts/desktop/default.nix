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

    ../../modules/tools/plymouth

    ../../modules/tools/sddm
    ../../modules/desktops/hyprland
    # ../../modules/desktops/cosmic

    ../../modules/terminal/zsh
    ../../modules/terminal/kitty

    ../../modules/editors/vscodium
    ../../modules/editors/jetbrains
    ../../modules/gaming/steam
    ../../modules/tools/cad

    ../../modules/virt/virt-manager
    ../../modules/theming/darkman
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

  networking.hostName = "fabians-nix-desktop";
  #  networking.extraHosts = ''
  #    192.168.178.157 esphome.internal
  #    192.168.178.157 hass.internal
  #    127.0.0.1 airshow-manager.internal
  #  '';
  #     127.0.0.1 airshow-manager.internal
  # 192.168.178.157 airshow-manager.internal

  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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
    nvtopPackages.amd
    docker-compose
    sops
    symfony-cli
    spotify
    headsetcontrol
    unstable.youtube-music
    prismlauncher
    r2modman

    wineWowPackages.waylandFull
    winetricks
    lutris
    #flightgear

    comma

    firefox

    nextcloud-client
  ];

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


  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

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



  environment.persistence."/persist/impermanence" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
    ];
    files = [
      "/etc/machine-id"
    ];
  };


  services.yubikey-agent.enable = true;

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      systemd-udev-settle.enable = false;
    };
    user = {
      # services = {
      #   polkit-kde-authentication-agent-1 = {
      #     description = "polkit-kde-authentication-agent-1";
      #     wantedBy = ["graphical-session.target"];
      #     wants = ["graphical-session.target"];
      #     after = ["graphical-session.target"];
      #     serviceConfig = {
      #       Type = "simple";
      #       ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      #       Restart = "on-failure";
      #       RestartSec = 1;
      #       TimeoutStopSec = 10;
      #     };
      #   };
      # };
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

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  #  networking.firewall.allowedTCPPorts = [8080 8081 3979];
  #  networking.firewall.allowedUDPPorts = [3979];

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

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
  system.stateVersion = "23.05"; # Did you read the comment?
}
