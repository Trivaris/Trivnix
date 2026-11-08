{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    {
      config.assertions = [
        {
          assertion = lib.all (forward: forward.enableTCP || forward.enableUDP) (
            lib.attrValues config.host.preferences.reverseProxy.dumbPipes.portForwards
          );
          message = "Every reverse proxy port forward must enable TCP or UDP.";
        }
      ];
    };
}
