{ lib, libExtra, ... }:
let
  modules = with libExtra; importDir { dirPath = mkFlakePath "/home/modules/extended-cli"; asPath = false; };
  imports = with libExtra; importDir { dirPath = mkFlakePath "/home/modules/extended-cli"; };  
in
with lib;
{
  inherit imports;

  options.homeConfig.extendedCli = mkOption {
    type = types.listOf (types.enum modules);
    default = [];
    example = [ "btop" "eza" ];
    description = ''
      Advanced Configurations of Cli Tools.
    '';
  };
}