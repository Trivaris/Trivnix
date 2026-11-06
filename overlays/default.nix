{ inputs, ... }:
{
  perSystem = { config, final, ... }: {
    overlayAttrs = {
      spicetify-packages = inputs.spicetify-nix.legacyPackages.${final.stdenv.hostPlatform.system};
      inherit (config.packages)
        cfddns-middleware
        jtegranx
        minecraft-server-fabric
        quartz
        ;
    };
  };
}
