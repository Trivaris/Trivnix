{
  inputs,
  outputs,
  libExtra,
  ...
}:
{
  userconfig,
  hostconfig,
  configname,
  hosts,
}:
let
  configurations = import (libExtra.mkFlakePath /home/configurations);
in
inputs.home-manager.lib.homeManagerConfiguration {

  pkgs = libExtra.mkPkgs hostconfig.architecture;

  # Expose flake args to within the config
  extraSpecialArgs = {
    inherit
      userconfig
      hostconfig
      configname
      hosts;
    inherit
      inputs
      outputs
      libExtra;
  };

  modules = [
    # Flake entrypoint
    configurations."${username}"."${configname}"
  ];

}
