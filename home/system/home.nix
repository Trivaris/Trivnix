{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  home = {
    inherit (config.hostInfos) stateVersion;
    username = lib.mkDefault config.userInfos.name;
    homeDirectory = lib.mkDefault "/home/${config.userInfos.name}";

    sessionVariables = {
      TERMINAL = toString prefs.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };
  };
}
