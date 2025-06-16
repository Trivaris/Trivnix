{ lib, ... }:
{

  options.terminal = lib.mkOption {
    type = lib.types.str;
    default = "wezterm";
    description = "Default Terminal";
  };

}
