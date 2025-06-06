{ inputs, ... }:
let

  modules = [
    "base"
    "cli-utils"
    "fish"
    "fonts"
    "fzf"
    "hyprland"
    "nvim"
    "rofi"
    "secrets"
    "vscodium"
    "wayland"
    "wezterm"
  ];

in
{

  imports = [ ./credentials.nix ] ++ map (module: (inputs.self + "/modules/${module}.nix")) modules;

}
