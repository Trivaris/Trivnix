{
  flake.homeModules.system-core =
    {
      config,
      osConfig,
      ...
    }:
    {
      config.home = {
        inherit (osConfig.hostInfos) stateVersion;
        username = config.userInfos.name;
        homeDirectory = "/home/${config.userInfos.name}";
        uid = config.userInfos.uid;
        shell.enableZshIntegration = true;

        sessionVariables = {
          TERMINAL = config.vars.terminalEmulator;
          NIX_LOG = "info";
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
