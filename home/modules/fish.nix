{
  inputs,
  config,
  pkgs,
  lib,
  userconfig,
  ...
}:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.fish.enable = mkEnableOption "extended fish configuration";

  config = mkIf cfg.fish.enable {
    programs.fish = {
      enable = true;

      loginShellInit = ''
        set -x NIX_LOG info
        set -x TERMINAL wezterm
        zoxide init fish | source
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
      };

      functions = {
        cd.body = "z $argv";
        grep.body = "rg $argv";

        fix-endings = ''
          mv ./.git ../
          find . -type f -exec sed -i 's/\r$//' {} +
          mv ../.git ./
        '';
      };
    };

    programs.tmux.shell = "${pkgs.fish}/bin/fish";

    programs.eza.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };

}
