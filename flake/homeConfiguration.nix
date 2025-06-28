{
  inputs,
  outputs,
  home-manager,
  lib-extra,
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
  configurations = import (lib-extra.mkFlakePath /home/configurations);
in
home-manager.lib.homeManagerConfiguration {

  pkgs = lib-extra.mkPkgs architecture;

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
      lib-extra
      ;
  };

  modules = [
    # Flake entrypoint
    configurations."${username}"."${configname}"
  ];

}
