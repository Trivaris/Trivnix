{ inputs }:
let
  libExtra = {
    configs = import (libExtra.mkFlakePath /configs) { inherit (libExtra) resolveDir; };
    mkFlakePath = path: (inputs.self + (toString path));
    resolveDir = import ./resolveDir.nix {inherit inputs; inherit (libExtra) mkFlakePath; };

    pkgsConfig = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "libsoup-2.74.3"
      ];
    };
  };
in
libExtra
