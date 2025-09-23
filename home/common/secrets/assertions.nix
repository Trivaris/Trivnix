{ inputs }:
let
  private = inputs.trivnixPrivate;
  hasEmail = (private ? emailAccounts) && builtins.isAttrs private.emailAccounts;
  hasCalendar = (private ? calendarAccounts) && builtins.isAttrs private.calendarAccounts;
in
[
  {
    assertion = hasEmail;
    message = ''Invalid or missing inputs.trivnixPrivate.emailAccounts (expected attrset).'';
  }
  {
    assertion = hasCalendar;
    message = ''Invalid or missing inputs.trivnixPrivate.calendarAccounts (expected attrset).'';
  }
]
