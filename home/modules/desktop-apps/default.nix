{ lib, libExtra, ... }:
let
  inherit (lib) types mkOption;
  inherit (libExtra) mkFlakePath importDir;
  dirPath = mkFlakePath "/home/modules/desktop-apps";
  modules = importDir {
    inherit dirPath;
    asPath = false;
  };
  imports = importDir { inherit dirPath; };
in
{
  inherit imports;

  options.homeConfig.desktopApps = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [
      "spotify"
      "thunderbird"
    ];
    description = ''
      Desktop Apps that you want to enable.
    '';
  };
}
