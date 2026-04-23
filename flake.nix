{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Core/community modules
    disko.url = "github:nix-community/disko";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";

    # Extras and ecosystem modules
    nix-minecraft.url = "github:Yeshey/nix-minecraft";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    importTree.url = "github:vic/import-tree";

    hyprland.url = "github:hyprwm/Hyprland";

    # Non-flake sources
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs = inputs: import ./flake/outputs.nix inputs;
}
