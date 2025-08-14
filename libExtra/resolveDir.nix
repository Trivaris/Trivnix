{ inputs, mkFlakePath }:
{
  dirPath,
  mode,
  dropExtensions ? true,
  exclude ? [ ],
  depth ? 1,
  includeNonNix? false
}:
let
  inherit (inputs.nixpkgs.lib) hasSuffix removeSuffix concatLists;

  cleanEntry = entry:
    if dropExtensions then removeSuffix ".nix" entry else entry;

  # Recursive collector. `rel` is path relative to dirPath (with trailing slash or "").
  listEntries = dir: rel: remainingDepth:
    let
      contents = builtins.readDir (mkFlakePath dir);
      names    = builtins.attrNames contents;

      isDir = name: contents.${name} == "directory";

      # Prefer a directory over a file with the same stem
      dirNames = builtins.filter (name: isDir name) names;
      dirSet   = builtins.listToAttrs (builtins.map (name: { inherit name; value = true; }) dirNames);

      valid = builtins.filter (name:
        name != "default.nix"
        && (
          (hasSuffix ".nix" name
            && !(builtins.hasAttr (removeSuffix ".nix" name) dirSet))
          || (isDir name
              && builtins.pathExists (mkFlakePath "${dir}/${name}/default.nix"))
          || includeNonNix
        )
        && !(builtins.elem (removeSuffix ".nix" name) exclude)
      ) names;

      validFull = builtins.map (name: "${rel}${name}") valid;

      # Recurse only into directories WITHOUT default.nix
      recurseDirs = builtins.filter (name:
        isDir name
        && !builtins.pathExists (mkFlakePath "${dir}/${name}/default.nix")
      ) names;

      nested =
        if remainingDepth > 1 then
          concatLists (builtins.map (name:
            listEntries "${dir}/${name}" "${rel}${name}/" (remainingDepth - 1)
          ) recurseDirs)
        else
          [ ];
    in
      validFull ++ nested;

  collectedEntries = listEntries dirPath "" depth;

  operations = {
    names = (entries: builtins.map cleanEntry entries);

    paths = (entries:
      builtins.map (entry: mkFlakePath "${dirPath}/${entry}") entries
    );

    imports = (entries:
      builtins.listToAttrs (builtins.map (entry: {
        name  = cleanEntry entry;
        value = import (mkFlakePath "${dirPath}/${entry}");
      }) entries)
    );
  };
in
operations.${mode} collectedEntries
