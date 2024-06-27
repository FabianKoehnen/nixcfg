{ pkgs, config, user, ... }: {

  imports = [
    ../default.nix
  ];

  environment.etc."logid.cfg".text = ''
    devices: ({
      name: "MX Master 3S";
      dpi: 1000;
      
      smartshift: {
        on: true;
        threshold: 12;
        default_threshold: 12;
      };
      
      hiresscroll: {
        hires: false;
        invert: false;
        target: true;
        up: {
              mode: "Axis";
              axis: "REL_WHEEL";
              axis_multiplier: 2.0;
        },
        down: {
                mode: "Axis";
                axis: "REL_WHEEL";
                axis_multiplier: -2.0;
        }
      };

      buttons: (
        {
          cid: 0xc3;
          action = {
            type: "Gestures";
            gestures: (
              {
                direction: "Up";
                mode: "OnRelease";
                action =
                {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_UP"];
                };
              },              
              {
                direction: "Down";
                mode: "OnRelease";
                action =
                {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_DOWN"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action =
                {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_LEFT"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action =
                {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_RIGHT"];
                };
              },
              {
                direction: "None";
                mode: "OnRelease";
                action = {
                  type = "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_R"];
                };
              }
            );
          };
        }
      );

    });
  '';
}
