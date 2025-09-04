{ inputs, self }:
let
  inherit (inputs.trivnix-configs) configs commonInfos;
  inherit (inputs.nixpkgs) lib;
  inherit (lib) mapAttrs' nameValuePair concatMapAttrs;
  inherit (self) outputs;

  trivnixLib = inputs.trivnix-lib.lib.for self;
  systems = lib.mapAttrsToList (_: config: config.infos.architecture) configs;
  forAllSystems =
    func: builtins.listToAttrs (map (system: nameValuePair system (func system)) systems);

  inputOverlays = {
    nur = inputs.nur.overlays.default;
    minecraft = inputs.nix-minecraft.overlay;
    millennium = inputs.millennium.overlays.default;
  };

  mkHomeManager = import ./mkHomeManager.nix {
    inherit
      inputs
      outputs
      trivnixLib
      configs
      commonInfos
      inputOverlays
      ;
  };

  mkNixOS = import ./mkNixOS.nix {
    inherit
      inputs
      outputs
      trivnixLib
      configs
      commonInfos
      inputOverlays
      ;
  };
in
{
  overlays = (import ./overlays) {
    inherit (trivnixLib) resolveDir;
    inherit mapAttrs' nameValuePair;
  };

  devShells = forAllSystems (
    system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
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
    }
  );

  # Define NixOS configs for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = mapAttrs' (
    configname: _:
    nameValuePair configname (mkNixOS {
      inherit configname;
    })
  ) configs;

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
  ) configs;
}
