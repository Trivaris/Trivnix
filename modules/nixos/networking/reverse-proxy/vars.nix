{
  flake.nixosModules.networking-reverse-proxy =
    {
      lib,
      config,
      ...
    }:
    let
      hostPreferences = config.host.preferences;
      servicesToList = lib.mapAttrsToList (name: service: service.reverseProxy // { inherit name; });
      isService = pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false;
    in
    {
      options.vars.activeServices = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule (
            lib.recursiveUpdate lib.trivnix.reverseProxyOptions {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name of the active service registered with the reverse proxy";
                };
              };
            }
          )
        );
        readOnly = true;
        default =
          hostPreferences.reverseProxy.extraServices
          ++ (servicesToList ((lib.filterAttrs (_: pref: isService pref)) hostPreferences));
        description = "Services collected from enabled reverseProxy registrations";
      };
    };
}
