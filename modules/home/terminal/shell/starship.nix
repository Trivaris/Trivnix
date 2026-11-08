{
  flake.homeModules.terminal-shell =
    { osConfig, ... }:
    let
      scheme = osConfig.host.theming.scheme;
    in
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        presets = [ "nerd-font-symbols" ];

        settings = {
          add_newline = true;
          line_break.disabled = true;
          fill.symbol = " ";

          format = ''
            [┌─](bold ${scheme.base0C}) $username $directory $git_branch$git_status$all$fill$time
            [╰─](bold ${scheme.base0C})$character'';

          character = {
            success_symbol = "[┤](bold green)";
            error_symbol = "[┤](bold red)";
          };

          username = {
            show_always = true;
            style_user = "${scheme.base0B}";
            style_root = "${scheme.base08}";
            format = "[$user]($style) in";
          };

          directory = {
            style = "${scheme.base0D}";
            format = "[$path]($style)";
          };

          git_branch = {
            style = "${scheme.base0E}";
            format = "on [$branch]($style) ";
          };

          git_status = {
            style = "${scheme.base08}";
            format = "([\\[$all_status$ahead_behind\\]]($style) )";
          };

          time = {
            disabled = false;
            format = "[$time](${scheme.base05})";
          };
        };
      };
    };
}
