{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.jetbrainsIDEs = lib.mkOption {
    type = lib.pipe pkgs.jetbrains [
      builtins.attrNames
      lib.types.enum
      lib.types.listOf
    ];

    default = [ ];
    example = [
      "rust-rover"
      "idea-ultimate"
    ];

    description = ''
      Enable Jetbrains IDEs. Toolchains, LSPs, Linters are not provided.
      Currently WIP. This will be removed as soon as I find out how to make good devshells for individual projects.
    '';
  };

  config.home.packages = map (ide: pkgs.jetbrains.${ide}) prefs.jetbrainsIDEs;
}
