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
  options.homeConfig.thunderbird.enable = mkEnableOption "Enable Thunderbird";

  config = mkIf cfg.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${userconfig.name} = {
        isDefault = true;
      };
    };
  };
}