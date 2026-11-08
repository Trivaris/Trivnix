{
  flake.nixosModules.networking-openconnect =
    { config, ... }:
    {
      config.assertions = [
        {
          assertion =
            !config.host.preferences.openconnect.enable
            || (
              config.host.preferences.openconnect.user != null
              && config.host.preferences.openconnect.gateway != null
            );
          message = "host.preferences.openconnect.user and gateway must be set when OpenConnect is enabled.";
        }
      ];
    };
}
