inputs@{ self, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) trivnixConfigs;

  systems = import ./systems.nix { inherit lib trivnixConfigs; };
  trivnixLib = inputs.trivnixLib.lib.for { selfArg = self; };

  forAllSystems = import ./forAllSystems.nix { inherit inputs lib systems; };
  modules = import ./modules.nix { inherit inputs; };
  overlays = import ./overlays.nix { inherit inputs; };

  mkHomeManager = trivnixLib.mkHomeManager { inherit inputs overlays trivnixConfigs; };
  mkNixOS = trivnixLib.mkNixOS { inherit inputs overlays trivnixConfigs; };
in
{
  devShells = forAllSystems (import ./devShells.nix);

  checks = forAllSystems (
    import ./checks.nix {
      inherit (modules) homeManagerModules homeModules hostModules;
      inherit
        mkHomeManager
        mkNixOS
        self
        trivnixConfigs
        ;
    }
  );

  nixosConfigurations = import ./nixosConfigurations.nix {
    inherit (modules) homeModules hostModules;
    inherit lib mkNixOS trivnixConfigs;
  };

  homeConfigurations = import ./homeConfigurations.nix {
    inherit (modules) homeManagerModules homeModules;
    inherit lib mkHomeManager trivnixConfigs;
  };
}
