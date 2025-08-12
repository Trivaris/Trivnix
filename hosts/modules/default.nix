{ libExtra, ... }:
let
  inherit (libExtra) resolveDir;
in
{
  imports = resolveDir { dirPath = "/hosts/modules"; mode = "paths"; };
}
