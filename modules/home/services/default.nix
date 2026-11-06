{ self, ... }:
{
  imports = [
    ./syncthing
  ];

  flake.homeModules.services = {
    imports = [
      self.homeModules.services-syncthing
    ];
  };
}
