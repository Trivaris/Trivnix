{ self, ... }:
{
  imports = [
    ./core
    ./hyprland
    ./keymap
    ./openssh
    ./secrets
    ./ssh
    ./users
  ];

  flake.nixosModules.system = {
    imports = [
      self.nixosModules.system-core
      self.nixosModules.system-hyprland
      self.nixosModules.system-keymap
      self.nixosModules.system-openssh
      self.nixosModules.system-secrets
      self.nixosModules.system-ssh
      self.nixosModules.system-users
    ];
  };
}
