{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
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
        [┌─](bold ${theme.base0C}) $username $directory $git_branch$git_status$all$fill$time
        [╰─](bold ${theme.base0C})$character'';

      character = {
        success_symbol = "[┤](bold green)";
        error_symbol = "[┤](bold red)";
      };

      username = {
        show_always = true;
        style_user = "${theme.base0B}";
        style_root = "${theme.base08}";
        format = "[$user]($style) in";
      };

      directory = {
        style = "${theme.base0D}";
        format = "[$path]($style)";
      };

      git_branch = {
        style = "${theme.base0E}";
        format = "on [$branch]($style) ";
      };

      git_status = {
        style = "${theme.base08}";
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };

      time = {
        disabled = false;
        format = "[$time](${theme.base05})";
      };
    };
  };
}