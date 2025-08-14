{ lib, libExtra, ... }:
let
  inherit (lib) types mkOption;
  inherit (libExtra) resolveDir;
  dirPath = "/home/modules/extended-cli";
  modules = resolveDir { inherit dirPath; mode = "names"; };
  imports = resolveDir { inherit dirPath; mode = "paths"; };
in
{
  inherit imports;

  options.userPrefs.extendedCli = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [
      "btop"
      "eza"
    ];
    description = ''
      Advanced Configs of Cli Tools.
    '';
  };
}
