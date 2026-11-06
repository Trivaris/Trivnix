{
  flake.homeModules.terminal-cli =
    {
      config,
      osConfig,
      lib,
      ...
    }:
    let
      cli-prefs = config.user-prefs.cli;
      scheme = osConfig.theme-prefs.scheme;
    in
    {
      config = lib.mkIf cli-prefs.enable {
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
