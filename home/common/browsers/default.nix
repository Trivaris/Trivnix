{ lib, trivnixLib, ... }:
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
  options.userPrefs.browsers = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "chromium" ];
    description = "Your Browsers";
  };
}
