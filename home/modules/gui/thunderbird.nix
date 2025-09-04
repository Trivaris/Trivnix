{
  inputs,
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf nameValuePair;
  prefs = config.userPrefs;

  calendarSettings = lib.flatten (
    lib.mapAttrsToList (
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
    ) inputs.trivnix-private.calendarAccounts
  );
in
{
  config = mkIf (builtins.elem "thunderbird" prefs.gui) {
    programs.thunderbird = {
      enable = true;
      profiles.${userInfos.name} = {
        isDefault = true;
        settings = builtins.listToAttrs calendarSettings;
      };
    };
  };
}
