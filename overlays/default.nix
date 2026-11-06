{ inputs, ... }:
{
  perSystem = { config, ... }: {
    overlayAttrs = {
      inherit (config.packages)
        cfddns-middleware
        jtegranx
        minecraft-server-fabric
        quartz
        ;
    };
  };
}
