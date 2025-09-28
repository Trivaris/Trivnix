{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    nameValuePair
    mapAttrsToList
    flatten
    pipe
    ;

  prefs = config.userPrefs;
in
{
  options.userPrefs.misc = {
    otherPrograms = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "spicetify" ];
      description = ''
        Other Programs you want to enable.
        Used as `programs.<program>.enable = true`.
      '';
    };

    otherPackages = mkOption {
      type = types.attrsOf (types.listOf types.str);
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
      map (program: nameValuePair program { enable = true; }) prefs.misc.otherPrograms
    );

    home.packages =
      let
        generalPackages = map (package: pkgs.${package}) prefs.misc.otherPackages._general or [ ];
        nestedPackages =
          pipe
            [ "_general" ]
            [
              (removeAttrs prefs.misc.otherPackages)
              (mapAttrsToList (name: value: (map (package: pkgs.${name}.${package})) value))
              flatten
            ];
      in
      generalPackages ++ nestedPackages;
  };
}
