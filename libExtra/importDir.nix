inputs:
{
  dirPath,
  asPath ? true
}:
with inputs.nixpkgs.lib;
let
  contents = builtins.readDir dirPath;

  entries = builtins.attrNames contents;

  valid = builtins.filter (name:
    name != "default.nix" &&
    (
      hasSuffix ".nix" name ||
      (contents.${name} == "directory" &&
        builtins.pathExists (dirPath + "/${name}/default.nix"))
    )
  ) entries;
in
builtins.map (name: if asPath then (dirPath + "/${name}") else removeSuffix ".nix" name) valid