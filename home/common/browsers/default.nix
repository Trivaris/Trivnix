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
  options.userPrefs.browsers = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "chromium" ];
    description = ''
      Browser modules to install and configure from `home/common/browsers`.
      Each entry ensures the corresponding package is available for the user.
    '';
  };
}
