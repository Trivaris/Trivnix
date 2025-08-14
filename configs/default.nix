{ resolveDir }:
let
  common = import ./common.nix;
  configs = builtins.filter (entry: !(builtins.elem entry [ "common.nix" "default.nix" ])) (builtins.attrNames (builtins.readDir ./.));
  mkConfig = (configname:
  let
    parts = resolveDir { dirPath = "/configs/${configname}"; mode = "imports"; };
  in
    parts // { users = parts.users (common.user); prefs = parts.prefs (common.host); }
  );
in
builtins.listToAttrs (map (config: {
  name = config;
  value = (mkConfig config);
}) configs)