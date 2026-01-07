{
  config,
  hostInfos,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkDefault;
  prefs = config.userPrefs;
in
{
  stylix.enable = true;
  home = {
    inherit (hostInfos) stateVersion;
    username = mkDefault userInfos.name;
    homeDirectory = mkDefault "/home/${userInfos.name}";

    sessionVariables = {
      TERMINAL = toString prefs.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };
  };
}
