{
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (trivnixLib) resolveDir;

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
        default = modules;
        example = [ "eza" ];
        description = ''
          CLI modules to enable for this user from `home/modules/cli`.
          Each selection loads additional config for the named tool.
        '';
      };

      replaceDefaults = mkOption {
        type = types.listOf (types.enum modules);
        default = modules;
        example = [ "eza" ];
        description = ''
          CLI programs that should replace system defaults when available.
          Use this to swap out commands like `ls` or `cat` with enhanced variants.
        '';
      };
    };

    vars.cliReplacements = mkOption {
      type = types.listOf (types.enum modules);
      default = [ ];
    };
  };
}
