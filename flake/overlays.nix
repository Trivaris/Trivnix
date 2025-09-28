{ inputs }:
{
  adbAutoPlayer = inputs.adbAutoPlayer.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;
  # millennium = inputs.millennium.overlays.default;
  nixowos = inputs.nixowos.overlays.fastfetch;
  nur = inputs.nur.overlays.default;
  trivnixAdd = inputs.trivnixOverlays.overlays.additions;
  trivnixMod = inputs.trivnixOverlays.overlays.modifications;
}
