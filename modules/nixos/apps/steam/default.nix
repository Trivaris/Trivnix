{
  flake.nixosModules.apps-steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      steam-prefs = config.host-prefs.steam;
    in
    {
      options.host-prefs.steam.enable = lib.mkEnableOption "Steam with bundled compatibility tooling on this host";

      config = lib.mkIf steam-prefs.enable {
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
