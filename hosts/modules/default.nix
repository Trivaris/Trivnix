{ libExtra,  lib, ... }:
with libExtra;
{
  imports = importDir { dirPath = (mkFlakePath "/hosts/modules"); };
}
