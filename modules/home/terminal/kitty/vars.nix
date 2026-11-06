{
  flake.homeModules.terminal-direnv =
    { lib, ... }:
    {
      options.vars.terminal-emulator = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        readOnly = true;
        description = "Terminal emulator selected by the desktop configuration";
      };
    };
}
