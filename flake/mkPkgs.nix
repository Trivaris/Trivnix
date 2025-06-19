{ inputs, outputs }:
let
  overlayList = with outputs.overlays; [
    additions
    modifications
    stable-packages
    nur
  ];

  pkgsConfig = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    android_sdk.accept_license = true;
  };

in
{
  inherit overlayList pkgsConfig;

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = overlayList;
      config = pkgsConfig;
    };
}
