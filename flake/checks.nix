{
  self,
  trivnixConfigs,
  mkNixOS,
  mkHomeManager,
  hostModules,
  homeModules,
  homeManagerModules,
}:
pkgs:
let
  inherit (pkgs.lib)
    filterAttrs
    pipe
    mapAttrs'
    nameValuePair
    concatMapAttrs
    ;

  hostsForSystem = filterAttrs (_: cfg: cfg.infos.architecture == pkgs.system) trivnixConfigs.configs;

  evalNixos = pipe hostsForSystem [
    (mapAttrs' (
      configname: _:
      let
        nixos = mkNixOS { inherit configname hostModules homeModules; };
      in
      nameValuePair "eval-nixos-${configname}" (
        builtins.seq nixos.config.system.build.toplevel.drvPath (
          pkgs.runCommand "eval-nixos-${configname}" { } ''
            echo ok > $out
          ''
        )
      )
    ))
  ];

  evalHM = pipe hostsForSystem [
    (concatMapAttrs (
      configname: hostConfig:
      pipe hostConfig.users [
        (mapAttrs' (
          username: _:
          let
            hm = mkHomeManager {
              inherit configname username;
              homeModules = homeModules ++ homeManagerModules;
            };
          in
          nameValuePair "eval-home-${username}@${configname}" (
            builtins.seq (hm.activationPackage.drvPath or hm.activationPackage) (
              pkgs.runCommand "eval-home-${username}@${configname}" { } ''
                echo ok > $out
              ''
            )
          )
        ))
      ]
    ))
  ];

  lint =
    pkgs.runCommand "lint"
      {
        src = self;
        nativeBuildInputs = builtins.attrValues {
          inherit (pkgs)
            bash
            coreutils
            findutils
            nixfmt
            statix
            deadnix
            ;
        };
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
