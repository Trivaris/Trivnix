{ libExtra, ... }:
let
  inherit (libExtra) resolveDir;
in
{
  imports = resolveDir { dirPath = "/home/common"; mode = "paths"; };
}
