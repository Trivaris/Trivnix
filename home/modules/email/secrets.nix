{
  lib,
  config,
  ...
}:
let 
  emailSecrets = lib.pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: lib.nameValuePair "email-passwords/${account}" { }))
    builtins.listToAttrs
  ];
  calendarSecrets = lib.pipe (config.private.calendarAccounts.${config.userInfos.name} or { }) [
    builtins.attrNames
    (map (account: lib.nameValuePair "calendar-passwords/${account}" { }))
    builtins.listToAttrs
  ];
in
{
  config.sops.secrets = emailSecrets // calendarSecrets;
}