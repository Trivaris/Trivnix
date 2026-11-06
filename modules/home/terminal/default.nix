{ self, ... }:
{
  imports = [
    ./cli
    ./direnv
    ./git
    ./kitty
    ./nvim
    ./shell
  ];

  flake.homeModules.terminal = {
    imports = [
      self.homeModules.terminal-cli
      self.homeModules.terminal-direnv
      self.homeModules.terminal-git
      self.homeModules.terminal-kitty
      self.homeModules.terminal-nvim
      self.homeModules.terminal-shell
    ];
  };
}
