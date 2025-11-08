{
  modules,
  mkHomeManager,
  mkNixOS,
  inputs,
  lib,
  stdenv,
  runCommand,
  bash,
  coreutils,
  deadnix,
  findutils,
  nixfmt,
  statix,
}:
let
  inherit (lib)
    concatMapAttrs
    filterAttrs
    mapAttrs'
    nameValuePair
    ;

  hostsForSystem = filterAttrs (
    _: cfg: cfg.infos.architecture == stdenv.hostPlatform.system
  ) inputs.trivnixConfigs.configs;

  evalNixos = mapAttrs' (
    configname: _:
    let
      nixos = mkNixOS {
        inherit (modules) homeModules hostModules;
        inherit configname;
      };
    in
    nameValuePair "eval-nixos-${configname}" (
      builtins.seq nixos.config.system.build.toplevel.drvPath (
        runCommand "eval-nixos-${configname}" { } ''
          echo ok > $out
        ''
      )
    )
  ) hostsForSystem;

  evalHM = concatMapAttrs (
    configname: hostConfig:
    mapAttrs' (
      username: _:
      let
        hm = mkHomeManager {
          inherit configname username;
          homeModules = modules.homeModules ++ modules.homeManagerModules;
        };
      in
      nameValuePair "eval-home-${username}@${configname}" (
        builtins.seq (hm.activationPackage.drvPath or hm.activationPackage) (
          runCommand "eval-home-${username}@${configname}" { } ''
            echo ok > $out
          ''
        )
      )
    ) hostConfig.users
  ) hostsForSystem;

  lint =
    runCommand "lint"
      {
        src = inputs.self;
        nativeBuildInputs = [
          bash
          coreutils
          deadnix
          findutils
          nixfmt
          statix
        ];
      }
      ''
        cp -r "$src" repo
        chmod -R u+w repo
        cd repo

        # Run format and lint tools across all Nix files
        find . -type f -name '*.nix' -print0 | xargs -0 -r nixfmt --check
        statix check .
        deadnix --fail -- --no-cargo .

        cd - >/dev/null
        echo OK > "$out"
      '';
in
{ inherit lint; } // evalNixos // evalHM
