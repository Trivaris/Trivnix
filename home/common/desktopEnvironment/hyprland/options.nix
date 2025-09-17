lib:
let
  inherit (lib) mkOption types;
in
{
  wallpapers = mkOption {
    type = types.listOf types.path;
    default = [ ];
    description = ''
      List of image paths Hyprland cycles through as wallpapers.
      Provide absolute paths so the Hyprland module can copy them into place.
    '';
  };
}
