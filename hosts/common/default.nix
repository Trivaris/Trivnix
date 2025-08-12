{ libExtra, ... }:
let
  inherit (libExtra) resolveDir;
in
{
  imports = resolveDir { dirPath = "/hosts/common"; mode = "paths"; };
}
