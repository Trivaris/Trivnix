{
  lib,
  ...
}:
{
  options.hostPrefs.piHole = {
    enable = lib.mkEnableOption "Pi Hole, a DNS Sink";
    reverseProxy = lib.mkReverseProxyOption;
    lists = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enabled = lib.mkEnableOption "The Adlist";
          description = lib.mkOption { type = lib.types.str; };
          type = lib.mkOption { type = lib.types.enum [ "allow" "block" ]; };
          url = lib.mkOption { type = lib.types.str; };
        };
      });
    };
  };
}