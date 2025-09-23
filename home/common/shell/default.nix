{
  lib,
  trivnixLib,
  hostInfos,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (trivnixLib) resolveDir;

  modules = resolveDir {
    dirPath = ./.;
    preset = "moduleNames";
  };

  imports = resolveDir {
    dirPath = ./.;
    preset = "importList";
  };
in
{
  inherit imports;
  options = {
    userPrefs.shell = mkOption {
      type = types.enum modules;
      example = "fish";
      description = ''
        Primary login shell to configure for this user via Home Manager.
        Picks a module from `home/common/shell` which sets interpreter-specific tweaks.
      '';
    };

    vars = {
      shellAbbreviations = mkOption {
        type = types.attrsOf types.anything;
        default = {
          ".." = "cd ..";
          "..." = "cd ../../";

          "gstat" = "git status --short";
          "gadd" = "git add .";
          "gcomm" = "git commit -m ";
          "gpull" = "git pull";
          "gpush" = "git push";
          "gclone" = "git clone";
        };
      };

      shellFunctions = mkOption {
        type = types.attrsOf types.anything;
        default = {
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
