{ self, ... }:
{
  imports = [
    ./steam
  ];

  flake.nixosModules.apps = {
    imports = [
      self.nixosModules.apps-steam
    ];
  };
}
