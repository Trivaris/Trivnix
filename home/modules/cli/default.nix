{
  lib,
  config,
  trivnixLib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (trivnixLib) resolveDir;
  replacementModules = builtins.filter (
    module: builtins.elem module config.vars.defaultReplacementModules
  ) modules;

  modules = resolveDir {
    dirPath = ./.;
    preset = "moduleNames";
  };

  imports = resolveDir {
    dirPath = ./.;
    preset = "importList";
  };
in
{
  inherit imports;
  options = {
    userPrefs.cli = {
      enabled = mkOption {
        type = types.listOf (types.enum modules);
        default = [ ];
        example = [ "btop" ];
        description = "Advanced Configs of Cli Tools";
      };

      replaceDefaults = mkOption {
        type = types.listOf (types.enum replacementModules);
        default = replacementModules;
        example = [ "eza" ];
        description = "The CLI tools you want to replace the defaults";
      };
    };

    vars.defaultReplacementModules = mkOption {
      type = types.listOf (types.enum modules);
      default = [ ];
      description = "All of the cli modules that can replace defaults";
    };

  };
}
