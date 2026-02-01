{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  modules = builtins.attrValues (
    lib.packagesFromDirectoryRecursive {
      directory = ./_modules;
      callPackage =
        packagePath: _:
        pkgs.callPackage packagePath {
          inherit (osConfig) hostPrefs;
          inherit config;
        };
    }
  );
in
{
  programs.waybar = lib.mkIf (!osConfig.hostPrefs.headless){
    enable = true;
    style = lib.concatStringsSep "\n" (map (module: module.style) modules);
    settings.mainBar = lib.mergeAttrsList (map (module: module.settings) modules);

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
}
