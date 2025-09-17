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
        description = ''
          CLI modules to enable for this user from `home/modules/cli`.
          Each selection loads additional config for the named tool.
        '';
      };

      replaceDefaults = mkOption {
        type = types.listOf (types.enum replacementModules);
        default = replacementModules;
        example = [ "eza" ];
        description = ''
          CLI programs that should replace system defaults when available.
          Use this to swap out commands like `ls` or `cat` with enhanced variants.
        '';
      };
    };

    vars.defaultReplacementModules = mkOption {
      type = types.listOf (types.enum modules);
      default = [ ];
      description = ''
        Internal list of CLI modules capable of replacing default binaries.
        Individual modules append to this so replacements stay deduplicated.
      '';
    };

  };
}
