{
  config,
  lib,
  ...
}: 
with lib; 
  let cfg = config.features.cli.fish;
  in {
    
    options.features.cli.fish.enable = mkEnableOption "enable extended fish config";

    config = mkIf cfg.enable {
      programs.fish = {
        enable = true;
        loginShellInit = ''
          set -x NIX_PATH nixpkgs=channel:nixos-unstable
          set -x NIX_LOG info
          set -x TERMINAL ghostty

          if test (tty) = "/dev/tty1"
            exec Hyprland &> /dev/null
          end
        '';
        shellAbbrs = {
          ".." = "cd ..";
          "..." = "cd ../../";
          
          cd = "z";
          ls = "eza";
          grep = "rg";

          "gstat" = "git status --short";
          "gadd" = "git add";
          "gcomm" = "git commit -m ";
          "gpull" = "git pull";
          "gpush" = "git push";
          "gclone" = "git clone";
        }
      }
    }

}