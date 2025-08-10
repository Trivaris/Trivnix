inputs:
{
  dirPath,
  asPath ? true,
  asMap ? false
}:
let
  inherit (inputs.nixpkgs.lib) hasSuffix removeSuffix;
  contents = builtins.readDir dirPath;
  entries = builtins.attrNames contents;
  baseName = name: if (hasSuffix ".nix" name) then (removeSuffix ".nix" name) else name;
  mkPath   = name: dirPath + "/${name}";

  valid = builtins.filter (
    name:
    name != "default.nix"
    && (
      hasSuffix ".nix" name
      || (contents.${name} == "directory" && builtins.pathExists (dirPath + "/${name}/default.nix"))
    )
  ) entries;
in
if asMap then
  builtins.listToAttrs (
    builtins.map (n: {
      name  = baseName n;
      value = import (mkPath n);
    }) valid
  )
else
  builtins.map (name: if asPath then (dirPath + "/${name}") else removeSuffix ".nix" name) valid