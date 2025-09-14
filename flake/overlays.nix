{
  inputs,
  trivnixLib,
  lib,
}:
let
  overlaysFromRepo = (import ../overlays) {
    inherit (trivnixLib) resolveDir;
    inherit (lib) mapAttrs' nameValuePair;
  };
in
{
  nur = inputs.nur.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;
  millennium = inputs.millennium.overlays.default;
  nixowos = inputs.nixowos.overlays.fastfetch;
}
// overlaysFromRepo
