{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Personal repos
    trivnix-private.url = "git+ssh://git@github.com/trivaris/trivnix-private";

    trivnix-lib = {
      url = "github:trivaris/trivnix-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    trivnix-configs = {
      url = "github:trivaris/trivnix-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        trivnix-lib.follows = "trivnix-lib";
      };
    };

    # Core/community modules
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop/WM
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extras and ecosystem modules
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Yeshey/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium = {
      url = "git+https://github.com/trivaris/Millennium?ref=nix-update";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake sources
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    appflowy = {
      url = "github:appflowy-io/AppFlowy-Cloud";
      flake = false;
    };
  };
  outputs = inputs: import ./flake/outputs.nix inputs;
}
