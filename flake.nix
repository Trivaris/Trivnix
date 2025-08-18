{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Core Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nix Community Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Yeshey/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium = {
      url = "git+https://github.com/SteamClientHomebrew/Millennium";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private Information and other helper stuff
    trivnix-private = {
      url = "git+ssh://git@github.com/Trivaris/trivnix-private";
    };

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

    # Non Flake Inputs
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    appflowy = {
      url = "github:AppFlowy-IO/AppFlowy-Cloud";
      flake = false;
    };
  };

  outputs = inputs@{ self, ... }: import ./outputs.nix { inherit inputs self; };
}
