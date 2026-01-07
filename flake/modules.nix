{ inputs }:
{
  host = [
    inputs.cfddns.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.mailserver.nixosModules.default
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.nur.modules.nixos.default
    inputs.sops-nix.nixosModules.sops
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.nvf.nixosModules.default
    inputs.trivnixPrivate.nixosModules.pubKeys
    inputs.trivnixPrivate.nixosModules.emailAccounts
    inputs.trivnixPrivate.nixosModules.calendarAccounts
    inputs.trivnixPrivate.nixosModules.secrets
  ];

  home = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.trivnixPrivate.nixosModules.pubKeys
    inputs.trivnixPrivate.nixosModules.emailAccounts
    inputs.trivnixPrivate.nixosModules.calendarAccounts
    inputs.trivnixPrivate.nixosModules.secrets
  ];
}
