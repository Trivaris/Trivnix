{
  config,
  lib,
  flakePath,
  ...
}:
with lib; let
  cfg = config.features.cli.fish;
in {

  options.features.cli.fish.enable = mkEnableOption "enable extended fish configuration";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      loginShellInit = ''
        set -x NIX_PATH nixpkgs=channel:nixos-unstable
        set -x NIX_LOG info
        set -x TERMINAL ghostty

        start-hyprland
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
        set flakePath ${flakePath}
        echo "Updating and rebuilding from flake: $flakePath"
        begin
          cd $flakePath
          git pull
          sudo nixos-rebuild switch --flake $flakePath#trivlaptop;"
        end
      '';
    };
  };

}