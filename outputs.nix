inputs@{ self, ... }:
let
  inherit (inputs.nixpkgs.lib)
    mapAttrs'
    nameValuePair
    concatMapAttrs
    mapAttrsToList
    unique
    ;

  trivnixConfigs = inputs.trivnix-configs;
  trivnixLib = inputs.trivnix-lib.lib.for self;
  mkHomeManager = trivnixLib.mkHomeManager dependencies;
  mkNixOS = trivnixLib.mkNixOS dependencies;
  systems = trivnixConfigs.configs |> mapAttrsToList (_: config: config.infos.architecture) |> unique;

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

  forAllSystems =
    func:
    systems
    |> map (system: nameValuePair system (func (import inputs.nixpkgs { inherit system; })))
    |> builtins.listToAttrs;

  overlays = {
    nur = inputs.nur.overlays.default;
    minecraft = inputs.nix-minecraft.overlay;
    millennium = inputs.millennium.overlays.default;
    nixowos = inputs.nixowos.overlays.fastfetch;
  }
  // (import ./overlays) {
    inherit (trivnixLib) resolveDir;
    inherit mapAttrs' nameValuePair;
  };

  dependencies = {
    inherit
      inputs
      overlays
      trivnixLib
      trivnixConfigs
      ;
  };
in
{
  inherit overlays;

  # Define NixOS configs for each host
  # Format: configname = <NixOS config>
  nixosConfigurations =
    trivnixConfigs.configs
    |> mapAttrs' (
      configname: _:
      nameValuePair configname (mkNixOS {
        inherit configname hostModules homeModules;
      })
    );

  # Define Home Manager configs for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations =
    trivnixConfigs.configs
    |> concatMapAttrs (
      configname: hostConfig:
      hostConfig.users
      |> mapAttrs' (
        username: userconfig:
        nameValuePair "${username}@${configname}" (mkHomeManager {
          inherit configname username;
          homeModules = homeModules ++ homeManagerModules;
        })
      )
    );

  devShells = forAllSystems (pkgs: {
    default = pkgs.mkShell {
      shellHook = "git config --local core.hooksPath .githooks";
      packages = builtins.attrValues {
        inherit (pkgs)
          git
          nixfmt
          statix
          deadnix
          shellcheck
          ;
      };
    };
  });
}
