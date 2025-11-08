{ inputs }:
{
  hostModules = [
    inputs.cfddns.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.mailserver.nixosModules.default
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.nixowos.nixosModules.default
    inputs.nur.modules.nixos.default
    inputs.sops-nix.nixosModules.sops
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.stylix.nixosModules.stylix
  ];

  homeModules = [
    inputs.adbAutoPlayer.homeModules.default
    inputs.nixowos.homeModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  homeManagerModules = [
    inputs.stylix.homeModules.stylix
  ];
}
