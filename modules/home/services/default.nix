{ self, ... }:
{
  flake.homeModules.services = {
    imports = [
      self.homeModules.services-syncthing
    ];
  };
}
