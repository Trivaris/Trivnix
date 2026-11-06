{ self, ... }:
{
  imports = [
    ./cfddns
    ./openconnect
    ./pihole
    ./reverse-proxy
    ./wireguard
  ];

  flake.nixosModules.networking = {
    imports = [
      self.nixosModules.networking-cfddns
      self.nixosModules.networking-openconnect
      self.nixosModules.networking-pihole
      self.nixosModules.networking-reverse-proxy
      self.nixosModules.networking-wireguard
    ];
  };
}
