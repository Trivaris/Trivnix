{
  flake.homeModules.terminal-direnv =
    { lib, ... }:
    {
      options.vars.terminalEmulator = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        readOnly = true;
      };
    };
}
