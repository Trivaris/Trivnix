{
  pkgs,
  lib,
  config,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.misc = {
    otherPrograms = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "spicetify" ];
      description = ''
        Other Programs you want to enable.
        Used as `programs.<program>.enable = true`.
      '';
    };

    otherPackages = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };

      example = {
        _general = [ "signal-desktop-bin" ];
        kdePackages = [ "gwenview" ];
      };

      description = ''
        Other Packages you want to add to home manager.
        _general designates top-level packages.
      '';
    };
  };

  config = {
    programs = builtins.listToAttrs (
      map (program: lib.nameValuePair program { enable = true; }) prefs.misc.otherPrograms
    );

    home.packages =
      let
        generalPackages = map (package: pkgs.${package}) prefs.misc.otherPackages._general or [ ];
        nestedPackages =
          lib.pipe
            [ "_general" ]
            [
              (removeAttrs prefs.misc.otherPackages)
              (lib.mapAttrsToList (name: value: (map (package: pkgs.${name}.${package})) value))
              lib.flatten
            ];
      in
      generalPackages ++ nestedPackages;
  };
}
