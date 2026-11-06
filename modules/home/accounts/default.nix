{ self, ... }:
{
  imports = [
    ./email
  ];

  flake.homeModules.accounts = {
    imports = [
      self.homeModules.accounts-email
    ];
  };
}
