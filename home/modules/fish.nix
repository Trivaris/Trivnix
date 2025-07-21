{
  inputs,
  config,
  pkgs,
  lib,
  userconfig,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.fish.enable = mkEnableOption "extended fish configuration";

  config = mkIf cfg.fish.enable {
    programs.fish = {
      enable = true;

      loginShellInit = ''
        set -x NIX_LOG info
        set -x TERMINAL wezterm
      '';

      interactiveShellInit = ''
        set fish_greeting
        fastfetch
      '';

      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../../";

        "gstat" = "git status --short";
        "gadd" = "git add";
        "gcomm" = "git commit -m ";
        "gpull" = "git pull";
        "gpush" = "git push";
        "gclone" = "git clone";

        "ls" = "eza";
        "grep" = "rg";
      };

      functions = {
        cd.body = "z $argv";

        start-kde = ''
          dbus-run-session -- startplasma-wayland
        '';
      };
    };

    programs.eza.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };

}
