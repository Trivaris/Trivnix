{ self, ... }:
{
  flake.homeModules.system = {
    imports = [
      self.homeModules.system-core
      self.homeModules.system-secrets
      self.homeModules.system-ssh
    ];
  };
}
