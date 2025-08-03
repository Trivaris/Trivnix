{
  inputs,
  config,
  lib,
  userconfig,
  ...
}:
let
  cfg = config.homeConfig;

  calendarSettings = lib.flatten (
    lib.mapAttrsToList (name: account:
    let
      prefix = "calendar.registry.${account.uuid}";
    in
    [
      { name = "${prefix}.type";      value = account.type; }
      { name = "${prefix}.uri";       value = account.uri; }
      { name = "${prefix}.username";  value = account.username; }
      { name = "${prefix}.name";      value = name; }
      { name = "${prefix}.color";     value = account.color; }
      { name = "${prefix}.disabled";  value = false; }
    ]) inputs.trivnix-private.calendarAccounts
  );
in
with lib;
{
  config = mkIf (builtins.elem "thunderbird" cfg.desktopApps) {
    programs.thunderbird = {
      enable = true;
      profiles.${userconfig.name} = {
        isDefault = true;
        settings = builtins.listToAttrs calendarSettings;
      };
    };
  };
}