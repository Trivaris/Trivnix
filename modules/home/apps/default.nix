{ self, ... }:
{
  flake.homeModules.apps = {
    imports = [
      self.homeModules.apps-librewolf
      self.homeModules.apps-prismlauncher
      self.homeModules.apps-remmina
      self.homeModules.apps-thunderbird
      self.homeModules.apps-vscode
    ];
  };
}
