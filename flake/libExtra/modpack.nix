{ pkgs, modpack, extra_mods ? [] }:

let
  modrinth_index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");
  files = builtins.filter (f: !(f ? env) || f.env.server != "unsupported") modrinth_index.files;
  downloads = builtins.map (f: pkgs.fetchurl {
    urls = f.downloads;
    inherit (f.hashes) sha512;
  }) files;
  paths = builtins.map (builtins.getAttr "path") files;

  derivations = pkgs.lib.zipListsWith (path: dl:
    let
      folder = builtins.head (builtins.match "(.*)/(.*$)" path);
    in pkgs.runCommand (baseNameOf path) { } ''
      mkdir -p "$out/${folder}"
      cp ${dl} "$out/${path}"
    ''
  ) paths downloads;

  fullPack = pkgs.symlinkJoin {
    name = "${modrinth_index.name}-${modrinth_index.versionId}";
    paths = derivations ++ [ "${modpack}/overrides" ] ++ extra_mods;
  };

  overridePath = "${modpack}/overrides";
  overrideDirs = builtins.filter
    (name: (builtins.readDir overridePath).${name} == "directory")
    (builtins.attrNames (builtins.readDir overridePath));

  symlinks = builtins.listToAttrs (map (name: {
    inherit name;
    value = "${overridePath}/${name}";
  }) overrideDirs);

in {
  path = fullPack;
  inherit symlinks;
}
