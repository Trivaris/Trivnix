{
  config,
  lib,
  hostInfos,
  userInfos,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  stylix.enable = true;
  nixowos.enable = true;

  home = {
    inherit (hostInfos) stateVersion;
    username = lib.mkDefault userInfos.name;
    homeDirectory = lib.mkDefault "/home/${userInfos.name}";

    sessionVariables = {
      TERMINAL = toString prefs.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };
  };
}
