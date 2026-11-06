{ inputs, ... }:
{
  flake.nixosModules.external = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nur.modules.nixos.default
      inputs.epic-games-launcher.nixosModules.default
      inputs.spicetify-nix.nixosModules.default
      inputs.disko.nixosModules.default
    ];
  };
}
