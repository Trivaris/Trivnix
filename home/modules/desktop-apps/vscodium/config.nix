{ mkEnableOption }:
{
  enableLsp = mkEnableOption "Enable LSP and Formatting for Nix";
  fixServer = mkEnableOption "Fix Server Installation when remoting into this host via Open Remote extension.";
}
