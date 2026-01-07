{
  config,
  isNixos,
  lib,
  osConfig,
  pkgs,
  trivnixLib,
  ...
}:
let
  prefs = if isNixos then osConfig.hostPrefs else config.userPrefs;

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
if isNixos then
  { config.stylix = stylixConfig; }
else
  {
    options.userPrefs.stylix = stylixOptions;
    config.stylix = stylixConfig;
  }
