{ importDir, mkFlakePath }:
importDir {
  dirPath = mkFlakePath "/hosts/configurations";
  asMap = true;
}