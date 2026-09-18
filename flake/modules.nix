{ inputs }:
{
  host = _: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.mailserver.nixosModules.default
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops
      inputs.lanzaboote.nixosModules.lanzaboote
    ];
  };

  home = _: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
