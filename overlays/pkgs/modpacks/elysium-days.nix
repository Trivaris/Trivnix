{ pkgs, inputs }:

let
  fixedUnpack = pkgs.runCommand "elysium-days-unpacked" { } ''
    set -eux
    mkdir -p $out
    cd $out

    ${pkgs.unzip}/bin/unzip ${pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/lz3ryGPQ/versions/azCePsLz/Elysium%20Days%207.0.0.mrpack";
      sha256 = "sha256-/1xIPjUSV+9uPU8wBOr5hJ3rHb2V8RkdSdhzLr/ZJ2Y=";
    }} -d .
    
    chmod -R u+rwX .
  '';

  overridePath = "${fixedUnpack}/overrides";
  overrideDirs = builtins.filter
    (name: (builtins.readDir overridePath).${name} == "directory")
    (builtins.attrNames (builtins.readDir overridePath));

  symlinks = builtins.listToAttrs (map (name: {
    inherit name;
    value = "${overridePath}/${name}";
  }) overrideDirs);

in {
  pname = "Elysium Days";
  version = "7.0.0";
  src = fixedUnpack;
  inherit symlinks;
}
