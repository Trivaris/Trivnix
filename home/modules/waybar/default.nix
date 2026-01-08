{
  config,
  lib,
  pkgs,
  osConfig,
  trivnixLib,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf (prefs.desktopEnvironment == "hyprland") (
    let
      scheme = config.stylixPrefs.theme;
      getColor = trivnixLib.getColor pkgs scheme;
      modules = builtins.attrValues (
        lib.packagesFromDirectoryRecursive {
          directory = ./_modules;
          callPackage =
            path: _:
            pkgs.callPackage path {
              inherit (osConfig) hostPrefs;
              inherit getColor config;
            };
        }
      );
    in
    {
      programs.waybar = {
        enable = true;
        style = lib.concatStringsSep "\n" (map (module: module.style) modules);
        settings.mainBar = lib.mergeAttrsList (map (module: module.settings) modules);

        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
    }
  );
}
