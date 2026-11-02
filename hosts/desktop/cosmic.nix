{ cosmicLib, ... }:
{
  wayland.desktopManager.cosmic.configFile = {
    "com.system76.CosmicIdle" = {
      version = 1;
      entries = {
        "screen_off_time" = cosmicLib.cosmic.mkRON "optional" null;
        "suspend_on_ac_time" = cosmicLib.cosmic.mkRON "optional" null;
      };
    };
  };
}
