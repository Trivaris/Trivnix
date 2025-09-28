{
  inputs,
  lib,
  trivnixLib,
}:
let
  overlaysFromRepo = import ../overlays {
    inherit (trivnixLib) resolveDir;
    inherit (lib) mapAttrs' nameValuePair;
  };
in
overlaysFromRepo
// {
  adbAutoPlayer = inputs.adbAutoPlayer.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;
  # millennium = inputs.millennium.overlays.default;
  nixowos = inputs.nixowos.overlays.fastfetch;
  nur = inputs.nur.overlays.default;
}
