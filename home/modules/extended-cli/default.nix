{ libExtra,  lib, ... }:
with libExtra;
{
  imports = importDir lib (mkFlakePath "/home/modules/extended-cli");
}
