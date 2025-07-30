{ libExtra, ... }:
with libExtra;
{
  imports = importDir { dirPath = (mkFlakePath "/home/common"); };
}
