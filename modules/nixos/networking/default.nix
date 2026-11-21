{ self, ... }:
{
  flake.nixosModules.networking = {
    imports = [
      self.nixosModules.networking-cfddns
      self.nixosModules.networking-headscale
      self.nixosModules.networking-openconnect
      self.nixosModules.networking-pihole
      self.nixosModules.networking-tailscale
      self.nixosModules.networking-reverse-proxy
      self.nixosModules.networking-wireguard
    ];
  };
}
