inputs@{ self, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) trivnixConfigs;

  systems = import ./systems.nix { inherit lib trivnixConfigs; };
  trivnixLib = inputs.trivnixLib.lib.for self;

  forAllSystems = import ./forAllSystems.nix { inherit inputs lib systems; };
  modules = import ./modules.nix { inherit inputs; };
  overlays = import ./overlays.nix { inherit inputs lib trivnixLib; };

  dependencies = {
    inherit
      inputs
      overlays
      trivnixConfigs
      trivnixLib
      ;
  };

  mkHomeManager = trivnixLib.mkHomeManager dependencies;
  mkNixOS = trivnixLib.mkNixOS dependencies;
in
{
  inherit overlays;

  imports = trivnixLib.resolveDir {
    dirPath = ../home/common/desktopEnvironment/hyprland/waybar;
    preset = "importList";
  };

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
