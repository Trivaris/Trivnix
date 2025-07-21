{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.fish.enable = mkEnableOption "fish";

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

    home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";

    programs.eza.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };

}
