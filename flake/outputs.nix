inputs@{
  self,
  trivnixConfigs,
  trivnixLib,
  nixpkgs,
  ...
}:
let
  inherit (nixpkgs) lib;

  modules = import ./modules.nix { inherit inputs; };
  overlays = import ./overlays.nix { inherit inputs; };
  getPkgs = system: import nixpkgs { inherit system; };
  forAllSystems = func: lib.genAttrs systems func;

  systems = lib.unique (
    lib.mapAttrsToList (_: config: config.infos.architecture) trivnixConfigs.configs
  );

  mkHomeManager = trivnixLib.lib.mkHomeManager {
    inherit (trivnixConfigs) configs;
    inherit overlays modules;
    selfArg = self;
  };

  mkNixOS = trivnixLib.lib.mkNixOS {
    inherit (trivnixConfigs) configs;
    inherit overlays modules;
    selfArg = self;
  };
in
{

  # nixosModules.default = importTree ../host;
  # homeModules.default = importTree ../home;
  formatter = forAllSystems (system: (getPkgs system).nixfmt);
  checks = forAllSystems (system: {
    lint = (getPkgs system).callPackage ./lintCheck.nix { inherit self; };
  });
  devShells = forAllSystems (system: {
    default = (getPkgs system).callPackage ../shell.nix { pkgs = getPkgs system; };
  });

  nixosConfigurations = lib.mapAttrs (_: mkNixOS) trivnixConfigs.configs;

  homeConfigurations = lib.concatMapAttrs (
    configname: hostConfig:
    lib.mapAttrs' (
      username: userConfig:
      lib.nameValuePair "${username}@${configname}" (mkHomeManager {
        inherit hostConfig userConfig;
      })
    ) hostConfig.users
  ) trivnixConfigs.configs;

}
