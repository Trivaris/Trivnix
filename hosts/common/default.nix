{ libExtra, ... }:
let
  inherit (libExtra) importDir mkFlakePath;
in
{
  imports = importDir { dirPath = (mkFlakePath "/hosts/common"); };
}
