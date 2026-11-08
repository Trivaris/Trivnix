{
  flake.homeModules.system-core =
    { config, osConfig, ... }:
    {
      home = {
        inherit (osConfig.host.info) stateVersion;

        sessionVariables = {
          TERMINAL = config.vars.terminalEmulator;
          NIX_LOG = "info";
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
