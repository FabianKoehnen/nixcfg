{ pkgs
, user
, ...
}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  users.users.${user}.extraGroups = [ "scanner" "lp" ];

  services.printing.enable = true;
  services.printing.logLevel = "debug";
  services.printing.drivers = with pkgs; [
    cups-filters
    cups-browsed
    pkgs.gutenprint
    pkgs.hplipWithPlugin
    # pkgs.samsung-unified-linux-driver
    pkgs.brlaser
    pkgs.brgenml1lpr
    foomatic-db-ppds-withNonfreeDb
  ];


  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin pkgs.sane-airscan ];

  services.udev.packages = [ pkgs.sane-airscan ];

  environment.systemPackages = with pkgs; [
    system-config-printer
    simple-scan
  ];
}
