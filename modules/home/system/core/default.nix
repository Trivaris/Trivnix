{
  imports = [
    ./theming.nix
  ];

  flake.homeModules.system-core =
    {
      config,
      osConfig,
      ...
    }:
    {
      config.home = {
        inherit (osConfig.host-infos) stateVersion;
        username = config.home.username;
        homeDirectory = "/home/${config.home.username}";
        shell.enableZshIntegration = true;

        sessionVariables = {
          TERMINAL = config.vars.terminal-emulator;
          NIX_LOG = "info";
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
