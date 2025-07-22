{
  inputs,
  outputs
}:
{
  libExtra,
  userconfig,
  hostconfig,
  configname,
  hosts,
}:
let
  configurations = import (libExtra.mkFlakePath /home/configurations);
in
inputs.home-manager.lib.homeManagerConfiguration {

  pkgs = import inputs.nixpkgs {
    system = hostconfig.architecture;
    inherit (outputs) overlays;
    config = libExtra.pkgs-config;
  } ;

  # Expose flake args to within the config
  extraSpecialArgs = {
    inherit
      inputs
      outputs
      libExtra
      userconfig
      hostconfig
      configname
      hosts;
  };

  modules = [
    # Flake entrypoint
    configurations."${userconfig.name}"."${configname}"
  ];

}
