{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  # millennium = inputs.millennium.overlays.default;
  spicetify = _: prev: {
    spicePkgs = inputs.spicetify-nix.legacyPackages.${prev.stdenv.system};
  };
}
