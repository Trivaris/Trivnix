{
  modrinthUrl,
  hash,
  pkgs,
}:
let
  inherit (pkgs.lib) pathExists;
  index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");
  minecraftVersion = builtins.replaceStrings [ "." ] [ "_" ] index.dependencies.minecraft;
  fabricVersion = index.dependencies.fabric-loader;
  overrideEntries = builtins.attrNames (builtins.readDir "${modpack}/overrides");
  overridesPath = "${modpack}/overrides";
  files = overrides // mods;

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

  overrides =
    if pathExists overridesPath then
      builtins.listToAttrs (
        builtins.map (name: {
          inherit name;
          value = "${overridesPath}/${name}";
        }) overrideEntries
      )
    else
      { };
in
{
  pname = index.name;
  version = index.versionId;
  src = modpack;

  inherit
    files
    minecraftVersion
    fabricVersion
    ;
}
