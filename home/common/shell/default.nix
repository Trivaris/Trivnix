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
  options.userPrefs.shell = mkOption {
    type = types.enum modules;
    example = "fish";
    description = ''
      Primary login shell to configure for this user via Home Manager.
      Picks a module from `home/common/shell` which sets interpreter-specific tweaks.
    '';
  };

  config.programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      directory = {
        style = "blue";
      };
    };
  };
}
