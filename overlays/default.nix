{ inputs, ... }:
{
  flake.overlays.default = final: prev: {
    spicetify-packages = inputs.spicetify-nix.legacyPackages.${final.stdenv.hostPlatform.system};
    cfddns-middleware = prev.callPackage ../packages/cfddns-middleware.nix { };
    jtegranx = prev.callPackage ../packages/jtegranx.nix { };
    minecraft-server-fabric = prev.callPackage ../packages/minecraft-server-fabric.nix { };
    quartz = prev.callPackage ../packages/quartz.nix { };
  };
}
