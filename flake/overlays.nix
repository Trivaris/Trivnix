{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  trivnixNvim = inputs.trivnixNvim.overlays.default;
  spicetify = _: prev: {
    spicePkgs = inputs.spicetify-nix.legacyPackages.${prev.stdenv.system};
  };
}
