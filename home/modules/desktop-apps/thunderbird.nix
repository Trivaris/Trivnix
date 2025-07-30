{
  config,
  lib,
  userconfig,
  ...
}:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "thunderbird" cfg.desktopApps) {
    programs.thunderbird = {
      enable = true;
      profiles.${userconfig.name} = {
        isDefault = true;
      };
    };
  };
}