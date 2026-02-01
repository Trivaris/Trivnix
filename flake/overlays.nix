{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  trivnix = inputs.trivnixOverlays.overlays.default;
  millennium = inputs.millennium.overlays.default;
  spicetify = _: prev: {
    spicePkgs = inputs.spicetify-nix.legacyPackages.${prev.stdenv.system};
  };
}
