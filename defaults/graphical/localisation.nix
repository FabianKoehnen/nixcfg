{ lib, ... }:
{
  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console = {
    keyMap = lib.mkDefault "us";
  };
  services.xserver.xkb.layout = lib.mkDefault "eu";
}
