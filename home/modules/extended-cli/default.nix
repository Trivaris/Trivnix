{ lib, libExtra, ... }:
let
  inherit (lib) types mkOption;
  inherit (libExtra) mkFlakePath importDir;
  dirPath = mkFlakePath "/home/modules/extended-cli";
  modules = importDir {
    inherit dirPath;
    asPath = false;
  };
  imports = importDir { inherit dirPath; };
in
{
  inherit imports;

  options.homeConfig.extendedCli = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [
      "btop"
      "eza"
    ];
    description = ''
      Advanced Configurations of Cli Tools.
    '';
  };
}
