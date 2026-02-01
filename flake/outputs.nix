inputs@{
  importTree,
  ...
}:
let
  modules = import ./modules.nix { inherit inputs; };
in
{

  nixosModules = {
    default = importTree ../host;
    dependencies = modules.host;
  };

  homeModules = {
    default = importTree ../home;
    dependencies = modules.home;
  };

  overlays = import ./overlays.nix { inherit inputs; };
}
