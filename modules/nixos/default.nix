{ self, ... }:
{
  imports = [
    ./apps
    ./networking
    ./services
    ./system
    ./external.nix
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
