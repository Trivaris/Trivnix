{ modrinthUrl, hash }:
{ inputs, pkgs }:

let
  inherit (pkgs.lib) fileContents;

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

  index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");

  hexToBase64 = hex: builtins.readFile (pkgs.runCommand "hex-to-b64" {
    nativeBuildInputs = [ pkgs.openssl pkgs.unixtools.xxd ];
  } ''
    echo -n '${hex}' | xxd -r -p | openssl base64 -A > $out
  '');

  fetchHashedUrl = file: pkgs.fetchurl {
    url = builtins.head file.downloads;
    hash = "sha512-${hexToBase64 file.hashes.sha512}";
  };

  symlinks = builtins.listToAttrs (
    builtins.filter (entry: entry != null) (map (file:
      if builtins.hasAttr "sha512" file.hashes then {
        name = file.path;
        value = fetchHashedUrl file;
      } else null
    ) index.files)
  );

  files = inputs.nix-minecraft.lib.collectFilesAt "${modpack}" "overrides";

  minecraftVersion = builtins.replaceStrings [ "." ] [ "_" ] index.dependencies.minecraft;
  fabricVersion = index.dependencies.fabric-loader;
in
{
  pname = index.versionId;
  version = index.versionId;
  src = modpack;

  inherit
    symlinks
    files
    minecraftVersion
    fabricVersion;
}
