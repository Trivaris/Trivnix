{ self, ... }:
{
  flake.homeModules.default = {
    imports = [
      self.homeModules.accounts
      self.homeModules.apps
      self.homeModules.desktop-environment
      self.homeModules.services
      self.homeModules.system
      self.homeModules.terminal
    ];
  };
}
