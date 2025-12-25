{ inputs }:
{
  minecraft = inputs.nix-minecraft.overlay;
  nixowos = inputs.nixowos.overlays.fastfetch;
  nur = inputs.nur.overlays.default;
  trivnix = inputs.trivnixOverlays.overlays.default;
}
