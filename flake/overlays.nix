{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  nur = inputs.nur.overlays.default;
  trivnix = inputs.trivnixOverlays.overlays.default;
  # millennium = inputs.millennium.overlays.default;
}
