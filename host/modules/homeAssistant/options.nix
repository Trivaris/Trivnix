{
  lib,
  ...
}:
{
  options.hostPrefs.homeAssistant = {
    enable = lib.mkEnableOption "Home Assitant, a smart home server";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8123; };
    wireguard = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Wireguard client connection";
          port = lib.mkOption {
            type = lib.types.port;
            default = 51820;
          };
          serverIp = lib.mkOption {
            type = lib.types.str;
            default = "10.0.0.2/32";
          };
          allowedSubnet = lib.mkOption {
            type = lib.types.str;
            default = "192.168.178.0/24";
          };
          publicKeyFile = lib.mkOption {
            type = lib.types.path;
          };
        };
      };
    };
  };
}