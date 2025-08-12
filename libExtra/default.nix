{ inputs, outputs }:
let
  libExtra = {
    partitionLayouts = (libExtra.resolveDir { dirPath = "/partition-layouts"; mode = "imports"; }) // { none = { }; };
    pkgs-config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "libsoup-2.74.3"
      ];
    };

    mkFlakePath = path: (inputs.self + (toString path));
    resolveDir = import ./resolveDir.nix {inherit inputs; inherit (libExtra) mkFlakePath; };

    mkNixOSConfiguration = import ./nixosConfiguration.nix { inherit inputs outputs; };
    mkHomeConfiguration = import ./homeConfiguration.nix { inherit inputs outputs; };
  };
in
libExtra
