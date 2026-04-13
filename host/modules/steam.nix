{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.steam.enable = lib.mkEnableOption ''
    Install Steam with bundled compatibility tooling on this host.
    Toggle this when the machine should support gaming workloads.
  '';

  config = lib.mkIf prefs.steam.enable {
    environment.systemPackages = [
      pkgs.heroic
      pkgs.r2modman
      pkgs.steamtinkerlaunch
    ];
    
    programs.steam = {
      enable = true;

      protontricks.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [ pkgs.proton-ge-bin pkgs.steamtinkerlaunch ];
      extraPackages = [
        pkgs.yad
        pkgs.xrandr
        pkgs.bash
        pkgs.gawk
      ];
    };
  };
}
