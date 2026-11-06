{
  imports = [
    ./theming.nix
    ./user-infos.nix
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
        username = config.user-infos.name;
        homeDirectory = "/home/${config.user-infos.name}";
        uid = config.user-infos.uid;
        shell.enableZshIntegration = true;

        sessionVariables = {
          TERMINAL = config.vars.terminal-emulator;
          NIX_LOG = "info";
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
