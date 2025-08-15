{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable code-server (VS Code in the browser).";
  reverseProxy = mkReverseProxyOption 8888;
}
