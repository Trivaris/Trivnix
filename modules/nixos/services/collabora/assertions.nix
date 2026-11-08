{
  flake.nixosModules.services-collabora =
    { config, ... }:
    {
      config.assertions = [
        {
          assertion =
            !config.host.preferences.collabora.enable
            || config.host.preferences.collabora.nextcloudFQDNs != null;
          message = "host.preferences.collabora.nextcloudFQDNs must be configured when Collabora is enabled.";
        }
      ];
    };
}
