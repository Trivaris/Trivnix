{ importDir, mkFlakePath }:
importDir {
  dirPath = mkFlakePath "/home/configurations";
  asMap = true;
}