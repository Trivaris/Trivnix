{
  config,
  inputs,
  lib,
  pkgs,
  userInfos,
  ...
}:
let
  inherit (lib)
    flatten
    mapAttrsToList
    mkEnableOption
    mkIf
    nameValuePair
    ;

  prefs = config.userPrefs;

  calendarSettings = flatten (
    mapAttrsToList (
      name: account:
      let
        prefix = "calendar.registry.${account.uuid}";
      in
      [
        (nameValuePair "${prefix}.type" account.type)
        (nameValuePair "${prefix}.uri" account.uri)
        (nameValuePair "${prefix}.username" account.username)
        (nameValuePair "${prefix}.name" name)
        (nameValuePair "${prefix}.color" account.color)
        (nameValuePair "${prefix}.disabled" false)
      ]
    ) inputs.trivnixPrivate.calendarAccounts.${userInfos.name}
  );
in
{
  options.userPrefs.thunderbird.enable = mkEnableOption "Enable Thunderbird configuration.";
  config = mkIf prefs.thunderbird.enable {
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
