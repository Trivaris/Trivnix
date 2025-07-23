{ libExtra,  lib, ... }:
with libExtra;
{
  imports = importDir lib (mkFlakePath "/hosts/modules");
}
