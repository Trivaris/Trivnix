{ inputs, config, ... }:
let
  private = inputs.trivnixPrivate;
  hasEmail = (private ? emailAccounts) && builtins.isAttrs private.emailAccounts;
  hasCalendar = (private ? calendarAccounts) && builtins.isAttrs private.calendarAccounts;
in
{
  assertions = [
    {
      assertion = config.userPrefs.email.enable -> hasEmail;
      message = ''Invalid or missing inputs.trivnixPrivate.emailAccounts (expected attrset).'';
    }
    {
      assertion = config.userPrefs.email.enable -> hasCalendar;
      message = ''Invalid or missing inputs.trivnixPrivate.calendarAccounts (expected attrset).'';
    }
  ];
}
