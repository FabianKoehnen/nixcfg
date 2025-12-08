# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ config
, pkgs
, unstable
, user
, lib
, ...
}:
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../defaults/graphical/desktop

    ../../modules/tools/sddm
    # ../../modules/tools/cosmic-greet
    # ../../modules/desktops/hyprland
    ../../modules/desktops/cosmic

    ../../modules/editors/vscodium
    ../../modules/editors/jetbrains
    ../../modules/editors/zed
    # ../../modules/editors/neovim
    ../../modules/gaming/steam
    ../../modules/tools/cad
    ../../modules/tools/bambulab

    ../../modules/virt/virt-manager
    ../../modules/tools/waylus
    ../../modules/tools/appimage
    ../../modules/tools/typst

    # ../../modules/dev/godot
  ];
  nixpkgs.config = {
    permittedInsecurePackages = [
      "python3.13-ecdsa-0.19.1"
    ];
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

  environment.systemPackages = with pkgs; [
    keepassxc

    unstable.youtube-music
    prismlauncher
    r2modman
    blender
    krita
    gparted
    arduino-ide
    adafruit-nrfutil

    wineWowPackages.waylandFull
    winetricks
    unstable.dbeaver-bin

    nextcloud-client

    freecad
  ];

  services.lact.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  programs.adb.enable = true;

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
    package = unstable.ollama;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    environmentVariables = {
      OLLAMA_GPU_OVERHEAD = "500000000";
    };
  };

  services.open-webui = {
    # enable = true;
    enable = false;
    environment = {
      WEBUI_AUTH = "false";
    };
  };

  users = {
    mutableUsers = false;
    users.fabian = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "adbusers"
        "dialout"
        "plugdev"
      ];
      shell = pkgs.zsh;
    };
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

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      systemd-udev-settle.enable = false;
    };
  };

  services.ratbagd = {
    enable = true;
    package = unstable.libratbag;
  };

  services.udev = {
    enable = true;
    packages = [ pkgs.arduino ];
    extraRules = ''
      # SteelSeries Arctis Nova 7
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="2202", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="2206", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="220a", TAG+="uaccess"
    '';
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    3131
    8080
  ];
  #  networking.firewall.allowedUDPPorts = [3979];

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

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
