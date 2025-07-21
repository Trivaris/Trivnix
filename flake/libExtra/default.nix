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
    minecraft
  ];

  pkgs-config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    android_sdk.accept_license = true;
  };

  scripts = import ./scripts inputs.nixpkgs;

  partition-layouts = import (mkFlakePath /partitions);
in
{

  inherit overlay-list pkgs-config partition-layouts scripts;
  inherit mkFlakePath mkPkgs;

  mkNixOSConfiguration = import ./nixosConfiguration.nix;
  mkHomeConfiguration = import ./homeConfiguration.nix;
  mkModpack = import ./modpack.nix;

}
