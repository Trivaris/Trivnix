{ inputs, self, ... }:
{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    specialArgs.trivnixLib = self.lib;
    modules = [
      inputs.trivnixPrivate.nixosModules.default
      self.diskoConfigurations.laptop
      self.nixosModules.external-modules
      self.nixosModules.common-theming
      self.nixosModules.common-wireguard
      self.nixosModules.laptop
      self.nixosModules.default
    ];
  };
}
