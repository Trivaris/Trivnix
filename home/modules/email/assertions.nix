{ inputs, prefs }:
let
  hasPrivate = inputs ? trivnixPrivate;
  hasEmail =
    hasPrivate
    && (inputs.trivnixPrivate ? emailAccounts)
    && builtins.isAttrs inputs.trivnixPrivate.emailAccounts;
in
[
  {
    assertion = prefs.email.enable -> hasPrivate;
    message = ''Email module enabled but input "trivnixPrivate" is missing. See docs/trivnix-private.md.'';
  }
  {
    assertion = prefs.email.enable -> hasEmail;
    message = ''Email module enabled but inputs.trivnixPrivate.emailAccounts is missing or not an attrset.'';
  }
]
