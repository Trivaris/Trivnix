{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.terminals = mkOption {
    type = types.listOf types.str;
    example = [ "wezterm" ];
    default = [ ];
    description = ''
      List of enabled terminal emulators.
      First will be used as default.
    '';
  };

  config = {
    programs = builtins.listToAttrs (map (terminal: {
      name = terminal;
      value = {
        enable = true;
      };
    }) cfg.terminals);
  };
}
