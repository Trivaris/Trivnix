{
  config,
  lib,
  pkgs,
  userInfos,
  ...
}:
let
  prefs = config.userPrefs;

  calendarSettings = lib.flatten (
    lib.mapAttrsToList (
      name: account:
      let
        prefix = "calendar.registry.${account.uuid}";
      in
      [
        (lib.nameValuePair "${prefix}.type" account.type)
        (lib.nameValuePair "${prefix}.uri" account.uri)
        (lib.nameValuePair "${prefix}.username" account.username)
        (lib.nameValuePair "${prefix}.name" name)
        (lib.nameValuePair "${prefix}.color" account.color)
        (lib.nameValuePair "${prefix}.disabled" false)
      ]
    ) config.private.calendarAccounts.${userInfos.name}
  );
in
{
  options.userPrefs.thunderbird.enable = lib.mkEnableOption "Enable Thunderbird configuration.";
  config = lib.mkIf prefs.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-bin;
      profiles.${userInfos.name} = {
        isDefault = true;
        settings = builtins.listToAttrs calendarSettings;
      };
    };
  };
}
