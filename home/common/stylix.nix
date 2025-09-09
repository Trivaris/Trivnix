{
  config,
  pkgs,
  lib,
  trivnixLib,
  isNixos,
  hostPrefs,
  ...
}:
let
  prefs = if !isNixos then config.userPrefs else hostPrefs;
  stylixOptions = import (trivnixLib.mkStorePath "/shared/stylix/options.nix") { inherit (lib) mkEnableOption mkOption types; };
  stylixConfig = import (trivnixLib.mkStorePath "/shared/stylix/config.nix") { inherit prefs pkgs config trivnixLib; };
in
if !isNixos then {
  options.userPrefs.stylix = stylixOptions;

  config.stylix = stylixConfig;
} else { }
