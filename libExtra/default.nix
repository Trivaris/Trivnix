{ inputs, outputs }: rec
{
  partition-layouts = import (mkFlakePath /partitions);
  pkgs-config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    android_sdk.accept_license = true;
  };

  mkFlakePath = path: (inputs.self + (toString path));
  importDir = import ./importDir.nix;

  mkNixOSConfiguration = import ./nixosConfiguration.nix { inherit inputs outputs; };
  mkHomeConfiguration = import ./homeConfiguration.nix { inherit inputs outputs; };
}
