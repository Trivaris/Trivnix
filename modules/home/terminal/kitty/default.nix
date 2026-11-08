{
  flake.homeModules.terminal-kitty =
    { osConfig, ... }:
    let
      hostTheming = osConfig.host.theming;
    in
    {
      config.programs.kitty = {
        enable = true;
        enableGitIntegration = true;
        shellIntegration.enableZshIntegration = true;

        settings = {
          cursor_trail = 1;
          cursor_trail_decay = "0.1 0.4";
          cursor_trail_start_threshold = 2;
          background_opacity = "0.7";
          dynamic_background_opacity = "yes";
          text_composition_strategy = "1.0 30";
        };

        extraConfig = ''
          ${
            if (hostTheming.themeOverrides.kitty != null) then
              "include ${hostTheming.themeOverrides.kitty}"
            else
              (import ./_theme.nix osConfig)
          }
        '';
      };
    };
}
