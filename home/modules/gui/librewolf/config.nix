lib:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  betterfox = mkEnableOption "Enable Betterfox User Config";
  clearOnShutdown = mkEnableOption "Clear all Site Data when closing Browser";

  allowedCookies = mkOption {
    type = types.listOf types.str;
    default = [ ];
    example = [ "https://accounts.google.com" ];
    description = "URLs of Domains that will keep their cookies after closing if `clearOnShutdown` is enabled";
  };
}
