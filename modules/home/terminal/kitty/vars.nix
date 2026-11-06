{
  flake.homeModules.terminal-direnv =
    { lib, ... }:
    {
      options.vars.terminalEmulator = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        readOnly = true;
        description = "Terminal emulator selected by the desktop configuration";
      };
    };
}
