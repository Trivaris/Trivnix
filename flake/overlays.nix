{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  # millennium = inputs.millennium.overlays.default;
  nixowos = inputs.nixowos.overlays.fastfetch;
  nur = inputs.nur.overlays.default;
  trivnix = inputs.trivnixOverlays.overlays.default;
}
