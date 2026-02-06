{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Personal Forks
    cfddns.url = "github:Trivaris/cloudflare-dyndns-nix";

    # Core/community modules
    disko.url = "github:nix-community/disko";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";

    # Extras and ecosystem modules
    # millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    nix-minecraft.url = "github:Yeshey/nix-minecraft";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nvf.url = "github:notashelf/nvf";
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    importTree.url = "github:vic/import-tree";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    # Non-flake sources
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs = inputs: import ./flake/outputs.nix inputs;
}
