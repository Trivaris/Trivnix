{
  config,
  lib,
  pkgs,
  trivnixLib,
  ...
}:
let
  prefs = config.hostPrefs;

  stylixOptions = import ../../shared/stylix/options.nix {
    inherit (lib) mkEnableOption mkOption types;
  };

  stylixConfig = import ../../shared/stylix/config.nix {
    inherit
      config
      pkgs
      prefs
      trivnixLib
      ;
  };
in
{
  options.hostPrefs.stylix = stylixOptions;
  config.stylix = stylixConfig;
}
