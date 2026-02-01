{
  lib,
  config,
  ...
}:
let 
  themePrefs = config.themingPrefs;
in 
{
  options.vars.terminalEmulator = lib.mkOption {
    type = lib.types.str;
    default = "kitty";
    readOnly = true;
  };

  config.programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    themeFile = themePrefs.schemes.kitty;
    font = {
      package = themePrefs.font;
      name = themePrefs.font.pname;
      size = 12;
    };

    settings = {
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      background_opacity = "0.7";
      dynamic_background_opacity = "yes";
      text_composition_strategy = "platform";
    };
  };
}
