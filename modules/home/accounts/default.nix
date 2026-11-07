{ self, ... }:
{
  flake.homeModules.accounts = {
    imports = [
      self.homeModules.accounts-email
    ];
  };
}
