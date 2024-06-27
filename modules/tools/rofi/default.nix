{ pkgs
, user
, lib
, config
, ...
}: {
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
  ];

  home-manager.users.${user}.programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-power-menu
        rofi-calc
      ];
      extraConfig = {
        terminal = "kitty";
        ssh-client = "kitten ssh -X";
        ssh-command = "{terminal} -e zsh -c \"stty intr ^X && {ssh-client} {host}\"";
        scroll-method = 1;
        show-icons = true;
        hide-scrollbar = false;
        sidebar-mode = true;
        disable-history = false;
        sorting-method = "fzf";
        window-format = "{w:4} {c:15} {t}";
        modi = "powermenu:${pkgs.rofi-power-menu}/bin/rofi-power-menu --symbols-font \"Symbols Nerd Font Mono\" --choices \"shutdown/lockscreen/suspend/hibernate/reboot\",combi,ssh";
        combi-modi = "window,drun";
        kb-cancel = "Escape,Alt+F1";
        kb-move-char-back = "Control+b";
        kb-move-char-forward = "Control+f";
        kb-mode-next = "Right";
        kb-mode-previous = "Left";
        font = "JetBrains Mono NF 16";
        display-combi = "🐢";
        display-power-menu = "󰐥";
      };

      theme =
        let
          # Use `mkLiteral` for string-like values that should show without
          # quotes, e.g.:
          # {
          #   foo = "abc"; =&gt; foo: "abc";
          #   bar = mkLiteral "abc"; =&gt; bar: abc;
          # };
          inherit (config.home-manager.users.${user}.lib.formats.rasi) mkLiteral;
        in
        lib.mkForce {
          "*" = {
            foreground = mkLiteral "#000000DD";
            background = mkLiteral "#fdfdf4e0";
            background-alt = mkLiteral "#5bb3e400";
            background-bar = mkLiteral "#1ea8f050";
            highlight = mkLiteral "#1e7abaf0";
            accent = mkLiteral "#38578faa";
            "3dborder" = mkLiteral "0 0 3px 2px";
            border-radius = mkLiteral "12px";
          };
          "window" = {
            transparency = "real";
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
            border = mkLiteral "0px";
            border-color = mkLiteral "@border";
            border-radius = mkLiteral "10px";
            location = mkLiteral "center";
            x-offset = 0;
            y-offset = 0;
            orientation = mkLiteral "horizontal";
          };
          "mainbox" = {
            background-color = mkLiteral "@background-alt";
            orientation = mkLiteral "vertical";
            children = map mkLiteral [ "inputbar" "mode-switcher" "listview" ];
            spacing = mkLiteral "2%";
            padding = mkLiteral "2% 1% 2% 1%";
          };
          "inputbar" = {
            children = map mkLiteral [ "prompt" "entry" ];
            background-color = mkLiteral "@background-bar";
            text-color = mkLiteral "@foreground";
            expand = false;
            border = mkLiteral "@3dborder";
            border-radius = mkLiteral "@border-radius";
            border-color = mkLiteral "@accent";
            margin = mkLiteral "0% 0% 0% 0%";
          };
          "prompt" = {
            enabled = true;
            padding = mkLiteral "1em";
            border = 0;
            border-color = mkLiteral "@highlight";
            border-radius = mkLiteral "5px";
            text-color = mkLiteral "@foreground";
            background-color = mkLiteral "@background";
            font = "JetBrains Mono NF 26";
            # text-color=                     "black";
          };
          "entry" = {
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "@foreground";
            placeholder-color = mkLiteral "@foreground";
            font = "JetBrains Mono NF 20";
            expand = true;
            horizontal-align = 0;
            placeholder = "";
            padding = mkLiteral "1.2em";
            blink = true;
          };
          "mode-switcher" = {
            background-color = mkLiteral "@background-alt";
            orientation = mkLiteral "horizontal";
          };
          "button" = {
            background-color = mkLiteral "@background";
            expand = false;
            border = mkLiteral "@3dborder";
            border-radius = mkLiteral "@border-radius";
            border-color = mkLiteral "@accent";
            margin = mkLiteral "0.5em 0.9em";
            padding = mkLiteral "1em 1.5em";
            font = "JetBrains Mono NF 20";
          };
          "button selected" = {
            background-color = mkLiteral "@background-bar";
            border = 0;
          };
          "listview" = {
            spacing = mkLiteral "5px";
            lines = 5;
            background-color = mkLiteral "@background-alt";
            cycle = true;
            dynamic = true;
            layout = mkLiteral "vertical";
            padding = mkLiteral "0 0 0 0";
            fixed-columns = false;
          };
          "element" = {
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
            orientation = mkLiteral "horizontal";
            border = mkLiteral "@3dborder";
            border-radius = mkLiteral "@border-radius";
            border-color = mkLiteral "@accent";
            padding = mkLiteral "2% 0 2% 1em";
            highlight = mkLiteral "@highlight";
          };
          "element selected" = {
            background-color = mkLiteral "@background-bar";
            text-color = mkLiteral "@foreground";
            border = 0;
          };
          "element-icon" = {
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "inherit";
            horizontal-align = mkLiteral "0.5";
            vertical-align = mkLiteral "0.5";
            size = mkLiteral "32px";
            border = mkLiteral "0px";
          };
          "element-text" = {
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "inherit";
            expand = true;
            margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
          };
        };
    };
  };
}
