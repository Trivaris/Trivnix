{ self, inputs, ... }:
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

  overlays = {
    nur = inputs.nur.overlays.default;
    minecraft = inputs.nix-minecraft.overlay;
    millennium = inputs.millennium.overlays.default;
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

  mkHomeManager = trivnixLib.mkHomeManager dependencies;
  mkNixOS = trivnixLib.mkNixOS dependencies;
in
{
  systems = trivnixConfigs.configs |> mapAttrsToList (_: config: config.infos.architecture) |> unique;

  flake = {
    inherit overlays;

    # Define NixOS configs for each host
    # Format: configname = <NixOS config>
    nixosConfigurations =
      trivnixConfigs.configs
      |> builtins.attrNames 
      |> map (configname: nameValuePair configname (mkNixOS configname))
      |> builtins.listToAttrs;

    # Define Home Manager configs for each user@hostname
    # Format: <user>@<hostname> (configname) = <Home Manager config>
    homeConfigurations = concatMapAttrs (
      configname: hostConfig:
      mapAttrs' (
        username: userconfig:
        nameValuePair "${username}@${configname}" (mkHomeManager {
          inherit configname username;
        })
      ) hostConfig.users
    ) trivnixConfigs.configs;
  };

  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
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
    };
}
