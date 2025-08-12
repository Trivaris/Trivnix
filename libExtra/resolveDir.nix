{ inputs, mkFlakePath }:
{
  dirPath,
  mode,
  dropExtensions? true,
}:
let
  inherit (inputs.nixpkgs.lib) hasSuffix removeSuffix;

  cleanEntry = entry:
    if dropExtensions
    then (removeSuffix entry)
    else entry;

  operations = {
    names = (entries:
      map(entry:
        cleanEntry entry
      ) entries
    );
    paths = (entries:
      builtins.map(entry:
        mkFlakePath "${dirPath}/${entry}"
      ) entries
    );
    imports = (entries:
      builtins.listToAttrs( builtins.map(entry:
        {
          name = cleanEntry entry;
          value = import (mkFlakePath "${dirPath}/${entry}");
        }
      ) entries)
    );
  };
in
let
  contents = builtins.readDir dirPath;
  entries = builtins.attrNames contents;

  valid = builtins.filter ( name:
    name != "default.nix" && (
      hasSuffix ".nix" name ||
      (contents.${name} == "directory" && builtins.pathExists (dirPath + "/${name}/default.nix"))
    )
  ) entries;
in
operations.${mode} valid
