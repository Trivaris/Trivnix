{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    pipe
    types
    ;

  prefs = config.userPrefs;
in
{
  options.userPrefs.jetbrainsIDEs = mkOption {
    type = pipe pkgs.jetbrains [
      builtins.attrNames
      types.enum
      types.listOf
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
