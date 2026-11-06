{ self, ... }:
{
  imports = [
    ./accounts
    ./apps
    ./desktop-environment
    ./services
    ./system
    ./terminal
  ];

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
