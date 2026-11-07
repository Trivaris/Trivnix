{ self, ... }:
{
  flake.nixosModules.apps = {
    imports = [
      self.nixosModules.apps-steam
    ];
  };
}
