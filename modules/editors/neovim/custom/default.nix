{ lib, user, pkgs, ... }:
let
  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = (filesIn ./plugins);
}
