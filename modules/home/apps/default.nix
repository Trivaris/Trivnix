{ self, ... }:
{
  flake.homeModules.apps = {
    imports = [
      self.homeModules.apps-librewolf
      self.homeModules.apps-prism-launcher
      self.homeModules.apps-remmina
      self.homeModules.apps-thunderbird
      self.homeModules.apps-vscode
    ];
  };
}
