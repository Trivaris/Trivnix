{
  flake.homeModules.terminal-cli =
    {
      config,
      osConfig,
      lib,
      ...
    }:
    let
      cliPreferences = config.user.preferences.cli;
      scheme = osConfig.host.theming.scheme;
    in
    {
      config = lib.mkIf cliPreferences.enable {
        programs.fastfetch = {
          enable = true;
          settings = {
            "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
            logo.source = "nixos_old_small";
            modules = import ./_modules.nix;
            display = {
              separator = " ";
              brightColor = true;
              disableLinewrap = true;
              hideCursor = true;

              color = {
                keys = scheme.base0D;
                title = scheme.base0D;
                separator = scheme.base03;
              };

              key = {
                type = "both";
                width = 15;
                paddingLeft = 1;
              };
            };
          };
        };
      };
    };
}
