{ inputs, outputs }:
let
  mkFlakePath = path: (inputs.self + (toString path));

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = overlay-list;
      config = pkgs-config;
    };

  overlay-list = with outputs.overlays; [
    additions
    modifications
    stable-packages
    nur
  ];

  pkgs-config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    android_sdk.accept_license = true;
  };

  partition-layouts = import (mkFlakePath /partitions);
in
{

  inherit overlay-list pkgs-config partition-layouts;
  inherit mkFlakePath mkPkgs;
  
  mkHostConfig = import ./mkHostConfig.nix  mkFlakePath;
  mkHomeConfig = import ./mkHomeConfig.nix  mkFlakePath;

}
