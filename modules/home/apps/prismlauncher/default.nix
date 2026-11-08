{
  flake.homeModules.apps-prismlauncher =
    { pkgs, lib, ... }:
    {
      options.user.preferences.prismlauncher.enable = lib.mkEnableOption "Prism Launcher configuration";

      config.home.packages = [
        (pkgs.prismlauncher.override {
          jdks = [
            pkgs.jre8
            pkgs.jre17_minimal
            pkgs.jre21_minimal
            pkgs.jre25_minimal
          ];
        })
      ];
    };
}
