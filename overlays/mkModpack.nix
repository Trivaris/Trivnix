{ pkgs, ... }:
{ modrinthUrl, hash }:
let
  hex2b64 = { pkgs, hex }:
    let
      script = pkgs.writeShellScript "hex2b64" ''
        echo -n '${hex}' | xxd -r -p | openssl base64 -A
      '';
    in
    builtins.readFile (
      pkgs.runCommand "hex2b64"
        { nativeBuildInputs = [ pkgs.openssl pkgs.unixtools.xxd ]; } " ${script} > $out "
    );
  
  modpack = pkgs.runCommand "unpacked" {
    nativeBuildInputs = [ pkgs.unzip ];
  } ''
    mkdir -p $out
    unzip -q ${pkgs.fetchurl {
      url = modrinthUrl;
      sha256 = hash;
    }} -d $out
    chmod -R u+rwX $out
  '';
  
  fetchHashedUrl = file: pkgs.fetchurl {
    url = builtins.head file.downloads;
    hash = "sha512-${hex2b64 pkgs file.hashes.sha512}";
  };

  index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");

  minecraftVersion = builtins.replaceStrings [ "." ] [ "_" ] index.dependencies.minecraft;
  fabricVersion = index.dependencies.fabric-loader;

  overrideEntries = builtins.attrNames (builtins.readDir "${modpack}/overrides");
  overridesPath = "${modpack}/overrides";

  modFiles = builtins.filter (file:
    builtins.hasAttr "sha512" file.hashes
    && ((file.env.server or "required") != "unsupported")
  ) index.files;

  mods = builtins.listToAttrs (map (file: {
    name = file.path;
    value = fetchHashedUrl file;
  }) modFiles);

  overrides =
    if pkgs.lib.pathExists overridesPath then
      builtins.listToAttrs (builtins.map (name: {
        name = name;
        value = "${overridesPath}/${name}";
      }) overrideEntries)
    else {};

  files = overrides // mods;
in
{
  pname = index.name;
  version = index.versionId;
  src = modpack;

  inherit
    files
    minecraftVersion
    fabricVersion;
}
