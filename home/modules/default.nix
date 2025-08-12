{ libExtra, ... }:
let
  inherit (libExtra) resolveDir;
in
{
  imports = resolveDir { dirPath = "/home/modules"; mode = "paths"; };
}
