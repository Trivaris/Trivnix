{
  mkHomeManager,
  mkNixOS,
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
  hostsForSystem = lib.filterAttrs (
    _: cfg: cfg.infos.architecture == stdenv.hostPlatform.system
  ) inputs.trivnixConfigs.configs;

  evalNixos = lib.mapAttrs' (
    configname: hostConfig:
    lib.nameValuePair "eval-nixos-${configname}" (
      builtins.seq (mkNixOS hostConfig).config.system.build.toplevel.drvPath (
        runCommand "eval-nixos-${configname}" { } ''
          echo ok > $out
        ''
      )
    )
  ) hostsForSystem;

  evalHM = concatMapAttrs (
    configname: hostConfig:
    lib.mapAttrs' (
      username: userConfig:
      let
        hm = mkHomeManager {
          inherit hostConfig userConfig;
        };
      in
      lib.nameValuePair "eval-home-${username}@${configname}" (
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
