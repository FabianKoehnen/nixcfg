{
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    config = {
      xdg.enable = true;
      home = {
        stateVersion = "23.11";
        packages = with pkgs; [
          piper

          # teamspeak_client
          signal-desktop
          # discord
        ];
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.zsh = {
        shellAliases = {
          "batcon" = "sudo su -c 'cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'";
          "batcon-on" =
            "sudo su -c 'echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'";
          "batcon-off" =
            "sudo su -c 'echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'";
        };
      };
    };
  };
}
