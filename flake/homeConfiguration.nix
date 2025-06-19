{
  inputs,
  outputs,
  home-manager,
  libExtra,
  ...
}:

{
  configname,
  hostname,
  stateVersion,
  architecture ? "x86_64-linux",
  username,
}:
let
  configurations = import (libExtra.mkFlakePath /home/configurations);
in
home-manager.lib.homeManagerConfiguration {

  pkgs = libExtra.mkPkgs architecture;

  # Expose flake args to within the config
  extraSpecialArgs = {
    inherit
      inputs
      outputs
      configname
      hostname
      stateVersion
      architecture
      username
      libExtra
      ;
  };

  modules = [
    # Flake entrypoint
    configurations."${username}"."${configname}"
  ];

}
