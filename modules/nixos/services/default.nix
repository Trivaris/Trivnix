{ self, ... }:
{
  imports = [
    ./actual
    ./affine
    ./codeserver
    ./collabora
    ./evolution-api
    ./forgejo
    ./glances
    ./homepage
    # ./mailserver
    ./matrix
    ./n8n
    ./paperless
    ./syncthing
    ./tandoor
    ./vaultwarden
  ];

  flake.nixosModules.services = {
    imports = [
      self.nixosModules.services-actual
      self.nixosModules.services-affine
      self.nixosModules.services-code-server
      self.nixosModules.services-collabora
      self.nixosModules.services-evolution-api
      self.nixosModules.services-forgejo
      self.nixosModules.services-glances
      self.nixosModules.services-homepage
      # self.nixosModules.services-mailserver
      self.nixosModules.services-matrix
      self.nixosModules.services-n8n
      self.nixosModules.services-paperless
      self.nixosModules.services-syncthing
      self.nixosModules.services-tandoor
      self.nixosModules.services-vaultwarden
    ];
  };
}
