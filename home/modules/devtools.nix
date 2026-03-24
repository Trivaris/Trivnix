{
  osConfig,
  lib,
  ...
}:
{
  config = lib.mkIf osConfig.hostPrefs.enableDevStuffs {
    
  };
}