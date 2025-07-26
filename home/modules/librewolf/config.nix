lib:
with lib;
{
  enable = mkEnableOption "Enable LibreWolf with";
  
  betterwolf = mkEnableOption "Enable Betterfox User Config";
  
  clearOnShutdown = mkEnableOption "Clear all Site Data when closing Browser";
  
  allowedCookies = mkOption {
    type = types.listOf types.str;
    default = [];
    example = [ "https://accounts.google.com" "https://www.youtube.com" ];
    description = ''
      URLs of Domains that will keep their cookies after closing if `clearOnShutdown` is enabled 
    '';
  };
}