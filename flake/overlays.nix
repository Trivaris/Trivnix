{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  trivnix = inputs.trivnixOverlays.overlays.default;
  millennium = inputs.millennium.overlays.default;
}
