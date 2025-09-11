{
  config,
  lib,
  pkgs,
  hostInfos,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.autoUpgrade.enable = mkEnableOption "Wether to automatically update flake once a new commit is pushed";

  config = mkIf prefs.autoUpgrade.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "hourly";
      flags = [ "--refresh" ];
      flake = "github:Trivaris/trivnix#${hostInfos.configname}";
    };

    systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
      serviceConfig.ExecCondition = lib.getExe (
        pkgs.writeShellScriptBin "check-date" ''
          lastModified() {
            nix flake metadata "$1" --refresh --json | ${lib.getExe pkgs.jq} '.lastModified'
          }
          test "$(lastModified "${config.system.autoUpgrade.flake}")"  -gt "$(lastModified "self")"
        ''
      );
    };
  };
}
