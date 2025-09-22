{
  config,
  lib,
  hostInfos,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.shell == "fish") {
    programs = {
      fish = {
        enable = true;

        interactiveShellInit = ''
          set fish_greeting
          starship init fish | source
          ${if (builtins.elem "fastfetch" prefs.cli.enabled) then "fastfetch" else ""}
        '';

        shellAbbrs = {
          ".." = "cd ..";
          "..." = "cd ../../";

          "gstat" = "git status --short";
          "gadd" = "git add .";
          "gcomm" = "git commit -m ";
          "gpull" = "git pull";
          "gpush" = "git push";
          "gclone" = "git clone";
          "fix-endings" = ''find . -type f -not -path "./.git/*" -exec sed -i 's/\r$//' {} +'';
        };

        functions = {
          rebuild = ''
            set prod 0
            set host "${hostInfos.configname}"
            set host_set 0

            for arg in $argv
              if test "$arg" = "--prod"
                set prod 1
              else if test $host_set -eq 0
                set host $arg
                set host_set 1
              else
                echo "Usage: rebuild [--prod] [host]"
                return 1
              end
            end

            if test $prod -eq 1
              sudo nixos-rebuild switch --flake ".#$host"
            else
              sudo nixos-rebuild switch --flake ".#$host" \
                --override-input trivnixConfigs ../TrivnixConfigs/ \
                --override-input trivnixLib     ../TrivnixLib/ \
                --override-input trivnixPrivate ../TrivnixPrivate/
            end
          '';

          check = ''
            set prod 0
            set path "."
            set path_set 0

            for arg in $argv
              if test "$arg" = "--prod"
                set prod 1
              else if test $path_set -eq 0
                set path $arg
                set path_set 1
              else
                echo "Usage: check [--prod] [path=. ]"
                return 1
              end
            end

            if test $prod -eq 1
              nix flake check $path
            else
              nix flake check $path \
                --override-input trivnixConfigs ../TrivnixConfigs/ \
                --override-input trivnixLib     ../TrivnixLib/ \
                --override-input trivnixPrivate ../TrivnixPrivate/
            end
          '';
        };
      };
    };
  };
}
