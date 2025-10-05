{ inputs, prefs }:
let
  private = inputs.trivnixPrivate;
  hasWireguard = private ? wireguardInterfaces && builtins.isAttrs private.wireguardInterfaces;
in
[
  {
    assertion = prefs.wireguard.enable -> hasWireguard;
    message = ''Invalid or missing inputs.trivnixPrivate.wireguardInterfaces (expected attrset) while hostPrefs.wireguard.enable = true.'';
  }
]
