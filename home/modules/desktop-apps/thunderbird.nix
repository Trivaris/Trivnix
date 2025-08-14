{
  inputs,
  config,
  lib,
  userInfo,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;

  calendarSettings = lib.flatten (
    lib.mapAttrsToList (
      name: account:
      let
        prefix = "calendar.registry.${account.uuid}";
      in
      [
        {
          name = "${prefix}.type";
          value = account.type;
        }
        {
          name = "${prefix}.uri";
          value = account.uri;
        }
        {
          name = "${prefix}.username";
          value = account.username;
        }
        {
          name = "${prefix}.name";
          value = name;
        }
        {
          name = "${prefix}.color";
          value = account.color;
        }
        {
          name = "${prefix}.disabled";
          value = false;
        }
      ]
    ) inputs.trivnix-private.calendarAccounts
  );
in
{
  config = mkIf (builtins.elem "thunderbird" prefs.desktopApps) {
    programs.thunderbird = {
      enable = true;
      profiles.${userInfo.name} = {
        isDefault = true;
        settings = builtins.listToAttrs calendarSettings;
      };
    };
  };
}
