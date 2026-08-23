{
  pkgs,
  config,
  lib,
  ...
}:
let
  quartzPrefs = config.services.quartz;
in
{
  options = {
    services.quartz = {
      enable = lib.mkEnableOption "Quartz, a web renderer for obsidian";
    };
  };

  config = {
    systemd.services.quartz = {
      name = "Quartz";
      description = "Quartz, a web renderer for obsidian";
      ExecStart = "${pkgs.quartz}/bin/quartz";
    };
  };
}