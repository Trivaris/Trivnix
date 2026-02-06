{
  lib,
  osConfig,
  ...
}:
let 
  themePrefs = osConfig.themingPrefs;
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
    
    font = {
      package = themePrefs.font.package;
      name = themePrefs.font.name;
      size = 12;
    };

    settings = {
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      background_opacity = "0.7";
      dynamic_background_opacity = "yes";
      text_composition_strategy = "1.0 30";
    };

    extraConfig = ''
      ${if (themePrefs.themeOverrides.kitty != null) then "include ${themePrefs.themeOverrides.kitty}" else (import ./_theme.nix osConfig) }
    '';
  };
}
