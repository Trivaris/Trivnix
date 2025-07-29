{
  inputs,
  outputs
}:
{
  libExtra,
  userconfigs,
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
    overlays = builtins.attrValues (outputs.overlays);
    config = libExtra.pkgs-config;
  } ;

  # Expose flake args to within the config
  extraSpecialArgs = {
    inherit
      inputs
      outputs
      libExtra
      userconfigs
      userconfig
      hostconfig
      configname
      hosts;
  };

  modules = [
    # Flake entrypoint
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    
    configurations.${userconfig.name}.${configname}
  ];

}
