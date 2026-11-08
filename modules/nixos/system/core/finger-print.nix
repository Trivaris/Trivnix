{
  flake.nixosModules.system-core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.host.preferences.fingerPrintAuth = lib.mkEnableOption "Fingerprint authentication for sudo";

      config = lib.mkIf config.host.preferences.fingerPrintAuth {
        services.fprintd = {
          enable = true;
          tod.enable = true;
          tod.driver = pkgs.libfprint-2-tod1-goodix;
        };
      };
    };
}
