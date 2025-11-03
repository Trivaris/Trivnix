{ config, inputs, ... }:
let
  hasPrivate = inputs ? trivnixPrivate;
  hasEmail =
    hasPrivate
    && (inputs.trivnixPrivate ? emailAccounts)
    && builtins.isAttrs inputs.trivnixPrivate.emailAccounts;
in
{
  assertions = [
    {
      assertion = config.userPrefs.email.enable -> hasPrivate;
      message = ''Email module enabled but input "trivnixPrivate" is missing. See docs/trivnix-private.md.'';
    }
    {
      assertion = config.userPrefs.email.enable -> hasEmail;
      message = ''Email module enabled but inputs.trivnixPrivate.emailAccounts is missing or not an attrset.'';
    }
  ];
}
