lib:
let
  inherit (lib) mkOption types;
in
{
  wallpapers = mkOption {
    type = types.listOf types.path;
    default = [ ];
    description = "Paths to your wallpapers";
  };
}
