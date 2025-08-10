{ importDir, mkFlakePath }:
importDir {
  dirPath = mkFlakePath "/partition-layouts";
  asMap = true;
}
// { none = { }; }