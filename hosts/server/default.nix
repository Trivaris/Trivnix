{ inputs, self, ... }:
{
  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    specialArgs.trivnixLib = self.lib;
    modules = [
      inputs.trivnixPrivate.nixosModules.default
      self.diskoConfigurations.server
      self.nixosModules.external-modules
      self.nixosModules.common-theming
      self.nixosModules.common-wireguard
      self.nixosModules.server
      self.nixosModules.default
    ];
  };
}
