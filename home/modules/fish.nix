{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.fish = mkEnableOption "fish";

  config = mkIf cfg.fish {
    programs.fish = {
      enable = true;
      loginShellInit = ''
        
                set -x NIX_PATH nixpkgs=channel:nixos-unstable
                set -x NIX_LOG info
                set -x TERMINAL wezterm
        
                start-hyprland
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

      functions.cd.body = "z $argv";
      functions.start-hyprland = ''
        
                if test (tty) = "/dev/tty1"
                  exec Hyprland &> /dev/null
                end
      '';
      functions.nix-rebuild = ''
        
                set flakePath /etc/nixos
                set currentPath (pwd)
                echo flakePath: $flakePath
        
                begin
                  cd $flakePath
                  sudo git pull
                  sudo nix flake update dotfiles
                  sudo nixos-rebuild switch --flake $flakePath#hostname
                  cd $currentPath
                end
      '';
      functions.get-flakepath = ''
        
                echo ${inputs.self.outPath}
      '';
    };
  };

}
