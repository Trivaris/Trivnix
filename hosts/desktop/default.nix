{ inputs, self, ... }:
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    specialArgs.trivnixLib = self.lib;
    modules = [
      inputs.trivnixPrivate.nixosModules.default
      self.diskoConfigurations.desktop
      self.nixosModules.external-modules
      self.nixosModules.common-theming
      self.nixosModules.common-wireguard
      self.nixosModules.desktop
      self.nixosModules.default
    ];
  };
}
