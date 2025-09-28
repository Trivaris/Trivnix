{
  config,
  isNixos,
  lib,
  osConfig,
  pkgs,
  trivnixLib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mergeAttrsList
    mkIf
    pipe
    ;
in
{
  config = mkIf (config.userPrefs.desktopEnvironment == "hyprland") (
    let
      scheme = (if isNixos then osConfig else config).stylix.base16Scheme;
      getColor = trivnixLib.getColor { inherit pkgs scheme; };

      waybar =
        pipe
          {
            dirPath = ./.;
            preset = "importList";
          }
          [
            trivnixLib.resolveDir
            (map (
              path:
              import path {
                inherit (osConfig) hostPrefs;
                inherit config getColor lib;
              }
            ))
          ];
    in
    {
      programs.waybar = {
        enable = true;
        style = concatStringsSep "\n" (map (module: module.style) waybar);
        settings.mainBar = mergeAttrsList (map (module: module.settings) waybar);

        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
    }
  );
}
