{
  imports = [
    ./theming.nix
  ];

  flake.homeModules.system-core =
    { config, osConfig, ... }:
    {
      home = {
        inherit (osConfig.host-infos) stateVersion;

        sessionVariables = {
          TERMINAL = config.vars.terminal-emulator;
          NIX_LOG = "info";
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
