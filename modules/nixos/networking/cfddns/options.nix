{
  flake.nixosModules.networking-cfddns =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.cfddns = {
        enable = lib.mkEnableOption "Enable the cloudflare ddns server";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
