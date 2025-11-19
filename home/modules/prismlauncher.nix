{ pkgs, lib, ... }:
{
  options.userPrefs.prismlauncher.enable = lib.mkEnableOption "Enable Prism Launcher configuration";

  config.home.packages = [
    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.zulu8
        pkgs.zulu17
        pkgs.zulu21
      ];
    })
  ];
}
