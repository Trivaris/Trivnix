{
  config,
  lib,
  userInfos,
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
          fastfetch
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
          rm-clobbering = ''
            rm -f ~/.gtkrc-2.0.backup
            rm -f ~/.librewolf/${userInfos.name}/search.json.mozlz4.backup
            sudo rm -f ~/.config/gtk-3.0/gtk.css.backup
            sudo rm -f ~/.config/hypr/hyprland.conf.backup
          '';

          rebuild-prod = ''
            if test (count $argv) -lt 1
              echo "Usage: rebuild-dev <host>"
              return 1
            end
            set host $argv[1]
            sudo nixos-rebuild switch --flake ".#$host"
          '';

          check-prod = ''
            set path "."
            if test (count $argv) -ge 1
              set path $argv[1]
            end
            nix flake check $path
          '';

          rebuild-dev = ''
            if test (count $argv) -lt 1
              echo "Usage: rebuild-dev <host>"
              return 1
            end
            set host $argv[1]
            sudo nixos-rebuild switch --flake ".#$host" \
              --override-input trivnix-configs ~/Projects/trivnix-configs/ \
              --override-input trivnix-lib     ~/Projects/trivnix-lib/ \
              --override-input trivnix-private ~/Projects/trivnix-private/
          '';

          check-dev = ''
            set path "."
            if test (count $argv) -ge 1
              set path $argv[1]
            end
            nix flake check $path \
              --override-input trivnix-configs ~/Projects/trivnix-configs/ \
              --override-input trivnix-lib     ~/Projects/trivnix-lib/ \
              --override-input trivnix-private ~/Projects/trivnix-private/
          '';
        };
      };
    };
  };
}
