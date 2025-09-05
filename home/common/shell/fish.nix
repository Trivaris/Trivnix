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
      tmux.shell = "${pkgs.fish}/bin/fish";
      eza.enableFishIntegration = true;
      zoxide.enableFishIntegration = true;
      fzf.enableFishIntegration = true;

      fish = {
        enable = true;

        loginShellInit = ''
          set -x NIX_LOG info
          ${if prefs.terminalEmulator != null then "set -x TERMINAL ${prefs.terminalEmulator}" else ""}
        '';

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
        };

        functions = {
          cd.body = "z \"$argv\"";
          grep.body = "rg \"$argv\"";
          ls.body = "eza \"$argv\"";

          fix-endings = ''
            mv ./.git ../
            find . -type f -exec sed -i 's/\r$//' {} +
            mv ../.git ./
          '';

          rm-clobbering = ''
            rm -f ~/.gtkrc-2.0.backup
            rm -f ~/.librewolf/${userInfos.name}/search.json.mozlz4.backup
            sudo rm -f ~/.config/gtk-3.0/gtk.css.backup
          '';

          rebuild-dev = ''
            if test (count $argv) -lt 1
              echo "Usage: rebuild <host>"
              return 1
            end
            set host $argv[1]
            sudo nixos-rebuild switch --flake ".#$host" --override-input trivnix-configs ~/Projects/trivnix-configs/
          '';

          check-dev = ''
            nix flake check --override-input trivnix-configs ~/Projects/trivnix-configs/
          '';
        };
      };
    };
  };
}
