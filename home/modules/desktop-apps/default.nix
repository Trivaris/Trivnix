{ lib, libExtra, ... }:
let
  modules = with libExtra; importDir { dirPath = mkFlakePath "/home/modules/desktop-apps"; asPath = false; };
  imports = with libExtra; importDir { dirPath = mkFlakePath "/home/modules/desktop-apps"; };  
in
with lib;
{
  inherit imports;

  options.homeConfig.desktopApps = mkOption {
    type = types.listOf (types.enum modules);
    default = [];
    example = [ "spotify" "thunderbird" ];
    description = ''
      Desktop Apps that you want to enable.
    '';
  };
}