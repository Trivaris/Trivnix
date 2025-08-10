{ inputs, outputs }:
let
  libExtra = {
    partition-layouts = import (libExtra.mkFlakePath /partition-layouts) { inherit (libExtra) importDir mkFlakePath;};
    pkgs-config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "libsoup-2.74.3"
      ];
    };

    mkFlakePath = path: (inputs.self + (toString path));
    importDir = import ./importDir.nix inputs;

    mkNixOSConfiguration = import ./nixosConfiguration.nix { inherit inputs outputs; };
    mkHomeConfiguration = import ./homeConfiguration.nix { inherit inputs outputs; };
  };
in
libExtra
