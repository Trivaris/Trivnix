{
  lib,
  ...
}:
{
  options.hostPrefs.homeAssistant = {
    enable = lib.mkEnableOption "Home Assitant, a smart home server";
    reverseProxy = lib.mkReverseProxyOption;
    extraComponents = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "default_config"
        "google_translate"
        "mobile_app" 
        "met"
      ];
    };
  };
}