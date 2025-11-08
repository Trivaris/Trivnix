inputs@{
  self,
  trivnixConfigs,
  nixpkgs,
  importTree,
  ...
}:
let
  inherit (nixpkgs) lib;

  systems = import ./systems.nix { inherit lib trivnixConfigs; };
  trivnixLib = inputs.trivnixLib.lib.for { selfArg = self; };

  forAllSystems = import ./forAllSystems.nix { inherit inputs lib systems; };
  modules = import ./modules.nix { inherit inputs; };
  overlays = import ./overlays.nix { inherit inputs; };

  mkHomeManager = trivnixLib.mkHomeManager {
    inherit
      inputs
      overlays
      trivnixConfigs
      importTree
      ;
  };

  mkNixOS = trivnixLib.mkNixOS {
    inherit
      inputs
      overlays
      trivnixConfigs
      importTree
      ;
  };
in
{
  devShells = forAllSystems (
    { pkgs }:
    {
      default = pkgs.callPackage ../shell.nix { };
    }
  );

  formatter = forAllSystems ({ pkgs }: pkgs.nixfmt);

  checks = forAllSystems (
    { pkgs }:
    {
      lint = pkgs.callPackage ./lintCheck.nix {
        inherit
          inputs
          ;
      };
    }
  );

  nixosModules.default = importTree ../host;
  homeModules.default = importTree ../home;

  nixosConfigurations = import ./nixosConfigurations.nix {
    inherit (modules) homeModules hostModules;
    inherit lib mkNixOS trivnixConfigs;
  };

  homeConfigurations = import ./homeConfigurations.nix {
    inherit (modules) homeManagerModules homeModules;
    inherit lib mkHomeManager trivnixConfigs;
  };
}
