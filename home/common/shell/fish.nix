{
  config,
  pkgs,
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
          zoxide init fish | source
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
          "fix-endings" = ''find . -type f -not -path "./.git/*" -exec sed -i 's/\r$//' {} +'';
        };

        functions = {
          cd.body = "z \"$argv\"";
          grep.body = "rg \"$argv\"";
          ls.body = "eza \"$argv\"";

          rm-clobbering = ''
            rm -f ~/.gtkrc-2.0.backup
            rm -f ~/.librewolf/${userInfos.name}/search.json.mozlz4.backup
            sudo rm -f ~/.config/gtk-3.0/gtk.css.backup
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
            if test (count $argv) -lt 1
              echo "Usage: check-dev <flake-path>"
              return 1
            end
            set path $argv[1]
            nix flake check $path \
              --override-input trivnix-configs ~/Projects/trivnix-configs/ \
              --override-input trivnix-lib     ~/Projects/trivnix-lib/ \
              --override-input trivnix-private ~/Projects/trivnix-private/
          '';
        };
      };

      tmux.shell = "${pkgs.fish}/bin/fish";
      eza.enableFishIntegration = true;
      zoxide.enableFishIntegration = true;
      fzf.enableFishIntegration = true;
    };
  };
}
