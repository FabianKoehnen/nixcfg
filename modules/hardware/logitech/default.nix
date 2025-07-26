{ pkgs
, config
, ...
}: {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Install logiops package
  environment.systemPackages = [ pkgs.logiops ];

  # Create systemd service
  systemd.services.logiops = {
    description = "An unofficial userspace driver for HID++ Logitech devices";
    # wantedBy = [ "graphical.target" ];
    # after = [ "bluetooth.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.logiops}/bin/logid";
    };
    restartTriggers = [ config.environment.etc."logid.cfg".source ];
  };
}
