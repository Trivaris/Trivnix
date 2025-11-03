{
  config,
  isNixos,
  lib,
  pkgs,
  osConfig,
  trivnixLib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mergeAttrsList
    mkIf
    ;
in
{
  config = mkIf (config.userPrefs.desktopEnvironment == "hyprland") (
    let
      scheme = (if isNixos then osConfig else config).stylix.base16Scheme;
      getColor = trivnixLib.getColor scheme;
      modules = builtins.attrValues(lib.packagesFromDirectoryRecursive {
        directory = ./_modules;
        callPackage =
          path: _:
          pkgs.callPackage path {
            inherit (osConfig) hostPrefs;
            inherit getColor config;
          };
      });
    in
    {
      programs.waybar = {
        enable = true;
        style = concatStringsSep "\n" (map (module: module.style) modules);
        settings.mainBar = mergeAttrsList (map (module: module.settings) modules);

        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
    }
  );
}
