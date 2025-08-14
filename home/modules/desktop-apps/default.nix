{ lib, libExtra, ... }:
let
  inherit (lib) types mkOption;
  inherit (libExtra) resolveDir;
  dirPath = "/home/modules/desktop-apps";
  modules = resolveDir { inherit dirPath; mode = "names"; };
  imports = resolveDir { inherit dirPath; mode = "paths"; };
in
{
  inherit imports;

  options.userPrefs.desktopApps = mkOption {
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
