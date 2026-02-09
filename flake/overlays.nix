{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  hyprplugins = inputs.hyprland-plugins.overlays.default;
  split-monitor-workspaces = (
    final: prev: {
      split-monitor-workspaces =
        inputs.split-monitor-workspaces.packages.${prev.stdenv.system}.split-monitor-workspaces;
    }
  );
  # millennium = inputs.millennium.overlays.default;
  spicetify = _: prev: {
    spicePkgs = inputs.spicetify-nix.legacyPackages.${prev.stdenv.system};
  };
}
