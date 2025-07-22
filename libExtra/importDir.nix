lib: dirPath:
let
  contents = builtins.readDir dirPath;

  entries = builtins.attrNames contents;

  valid = builtins.filter (name:
    name != "default.nix" &&
    (
      lib.hasSuffix ".nix" name ||
      (contents.${name} == "directory" &&
        builtins.pathExists (dirPath + "/${name}/default.nix"))
    )
  ) entries;
in
builtins.map (name: dirPath + "/${name}") valid