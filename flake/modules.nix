{ inputs }:
{
  hostModules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.nvf.nixosModules.default
    inputs.nixowos.nixosModules.default
    inputs.mailserver.nixosModules.default
  ];

  homeModules = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nvf.homeManagerModules.default
    inputs.nixowos.homeModules.default
  ];

  homeManagerModules = [
    inputs.stylix.homeModules.stylix
  ];
}
