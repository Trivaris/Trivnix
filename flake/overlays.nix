{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  split-monitor-workspaces = (
    final: prev: {
      split-monitor-workspaces =
        inputs.split-monitor-workspaces.packages.${prev.stdenv.system}.split-monitor-workspaces;
    }
  );
  spicetify = _: prev: {
    spicePkgs = inputs.spicetify-nix.legacyPackages.${prev.stdenv.system};
  };
}
