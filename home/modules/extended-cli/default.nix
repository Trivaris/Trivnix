{ libExtra,  lib, ... }:
with libExtra;
{
  imports = importDir { dirPath = (mkFlakePath "/home/modules/extended-cli"); };
}
