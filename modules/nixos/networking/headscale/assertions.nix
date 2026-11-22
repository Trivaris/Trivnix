{
  flake.nixosModules.networking-headscale = { lib, config, ... }: {
    assertions = [
      {
        assertion = config.host.preferences.headscale.enable -> !(lib.hasSuffix config.host.preferences.headscale.dns.domain config.host.preferences.headscale.reverseProxy.domain);
        message = "headscale: dns.domain must not equal or be a parent of reverseProxy.domain";
      }
      {
        assertion = config.host.preferences.headplane.enable -> config.host.preferences.headscale.enable;
        message = "headplane may not be enabled without headscale";
      }
    ];
  };
}
