inputs@{ self, ... }:
let
  inherit (inputs.nixpkgs) lib;

  trivnixConfigs = inputs.trivnix-configs;
  trivnixLib = inputs.trivnix-lib.lib.for self;

  overlays = import ./overlays.nix { inherit inputs trivnixLib lib; };
  modules = import ./modules.nix { inherit inputs; };
  systems = import ./systems.nix { inherit trivnixConfigs lib; };
  forAllSystems = import ./forAllSystems.nix { inherit inputs systems lib; };

  dependencies = {
    inherit
      inputs
      overlays
      trivnixLib
      trivnixConfigs
      ;
  };

  mkHomeManager = trivnixLib.mkHomeManager dependencies;
  mkNixOS = trivnixLib.mkNixOS dependencies;
in
{
  inherit overlays;
  devShells = forAllSystems (import ./devShells.nix);

  checks = forAllSystems (
    import ./checks.nix {
      inherit
        self
        trivnixConfigs
        mkNixOS
        mkHomeManager
        ;
      inherit (modules) hostModules homeModules homeManagerModules;
    }
  );

  nixosConfigurations = import ./nixosConfigurations.nix {
    inherit mkNixOS trivnixConfigs lib;
    inherit (modules) hostModules homeModules;
  };

  homeConfigurations = import ./homeConfigurations.nix {
    inherit mkHomeManager trivnixConfigs lib;
    inherit (modules) homeModules homeManagerModules;
  };
}
