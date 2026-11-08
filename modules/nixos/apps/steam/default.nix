{
  flake.nixosModules.apps-steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      steamPreferences = config.host.preferences.steam;
    in
    {
      options.host.preferences.steam.enable =
        lib.mkEnableOption "Steam with bundled compatibility tooling on this host";

      config = lib.mkIf steamPreferences.enable {
        environment.systemPackages = [
          pkgs.heroic
          pkgs.r2modman
          pkgs.steamtinkerlaunch
        ];

        programs.gamescope.enable = true;
        programs.steam = {
          enable = true;

          protontricks.enable = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;

          extraCompatPackages = [
            pkgs.proton-ge-bin
            pkgs.steamtinkerlaunch
          ];
          extraPackages = [
            pkgs.yad
            pkgs.xrandr
            pkgs.bash
            pkgs.gawk
          ];
        };
      };
    };
}
