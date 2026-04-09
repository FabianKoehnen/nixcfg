# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../../modules/base/git
      ../../../modules/base/bin-bash-fix.nix
      ../../../modules/base/nix-ld.nix


      ../../../defaults/graphical/laptop

      # ../../../modules/tools/sddm
      ../../../modules/tools/cosmic-greet
      # ../../modules/desktops/hyprland
      ../../../modules/desktops/cosmic

      ../../../modules/editors/vscodium
      ../../../modules/editors/jetbrains
      ../../../modules/editors/zed

      ../../../modules/tools/appimage
      # ../../../modules/tools/llama-cpp
    ];

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

  networking.hostName = "blumenpeter-fabian-koehnen"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [ fira-sans ];

  environment.systemPackages = with pkgs; [
    keepassxc
    seahorse
    nvtopPackages.nvidia
    
    # Dev
    shopware-cli
    mkcert
    unstable.ddev
    dbeaver-bin

    ungoogled-chromium
    vivaldi
    obsidian
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
    extraPackages = [
      pkgs.docker-buildx
    ];
  };
  networking.firewall = {
    extraCommands = "
      iptables -I nixos-fw 1 -i br+ -j ACCEPT
    ";
    extraStopCommands = "
      iptables -D nixos-fw -i br+ -j ACCEPT
    ";
  };

  hardware = {
    bluetooth.enable = true;
    tuxedo-drivers.enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
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

  services.fwupd.enable = true;

  environment.etc.hosts.mode = "0644";

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    openFirewall = true;
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  users = {
    mutableUsers = false;
    users.fabian = {
      hashedPassword = "$y$j9T$6nEk9h.u19odKXIthjWuG.$pO27nAbzlkUlQuNupQvj17Tk0662v7JQlL4NsaMXkED";
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

  networking.firewall.allowedTCPPorts = [ 9003 443 ];


  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

