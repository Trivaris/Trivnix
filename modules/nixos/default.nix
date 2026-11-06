{ self, ... }:
{
  imports = [
    ./apps
    ./networking
    ./services
    ./system
  ];

  flake.nixosModules.default = {
    imports = [
      self.nixosModules.apps
      self.nixosModules.networking
      self.nixosModules.services
      self.nixosModules.system
    ];
  };
}
