{
  hash,
  modrinthUrl,
  pkgs,
}:
let
  inherit (pkgs.lib)
    nameValuePair
    optionals
    pathExists
    pipe
    ;

  index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");

  modpack = pkgs.runCommand "unpacked" { nativeBuildInputs = [ pkgs.unzip ]; } ''
    mkdir -p $out
    unzip -q ${
      pkgs.fetchurl {
        url = modrinthUrl;
        sha256 = hash;
      }
    } -d $out
    chmod -R u+rwX $out
  '';

  fetchHashedUrl =
    file:
    pkgs.fetchurl {
      url = builtins.head file.downloads;
      hash = "sha512:${file.hashes.sha512}";
    };

  modFiles = builtins.filter (
    file: builtins.hasAttr "sha512" file.hashes && ((file.env.server or "required") != "unsupported")
  ) index.files;

  mods = builtins.listToAttrs (
    map (file: {
      name = file.path;
      value = fetchHashedUrl file;
    }) modFiles
  );

  overrides = pipe "${modpack}/overrides" [
    builtins.readDir
    builtins.attrNames
    (map (name: nameValuePair name "${modpack}/overrides/${name}"))
    builtins.listToAttrs
    (optionals pathExists "${modpack}/overrides")
  ];
in
{
  pname = index.name;
  version = index.versionId;
  src = modpack;
  minecraftVersion = builtins.replaceStrings [ "." ] [ "_" ] index.dependencies.minecraft;
  fabricVersion = index.dependencies.fabric-loader;
  files = overrides // mods;
}
