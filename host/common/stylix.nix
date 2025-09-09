{
  config,
  pkgs,
  lib,
  trivnixLib,
  ...
}:
let
  prefs = config.hostPrefs;
  stylixOptions = import (trivnixLib.mkStorePath "/shared/stylix/options.nix") {
    inherit (lib) mkEnableOption mkOption types;
  };
  stylixConfig = import (trivnixLib.mkStorePath "/shared/stylix/config.nix") {
    inherit
      prefs
      pkgs
      config
      trivnixLib
      ;
  };
in
{
  options.hostPrefs.stylix = stylixOptions;

  config.stylix = stylixConfig;
}
