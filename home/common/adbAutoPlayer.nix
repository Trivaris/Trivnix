{ lib, ... }:
let
  inherit (lib) mkAliasOptionModule;
in
{
  imports = [ (mkAliasOptionModule [ "userPrefs" "adbAutoPlayer" ] [ "programs" "adbAutoPlayer" ]) ];
}
