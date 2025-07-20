{
  inputs,
  outputs,
  libExtra
}:
{
  configname,
  hostconfig,
  userconfigs,
  hosts
}:
let
  host-configurations = import (libExtra.mkFlakePath /hosts/configurations);
  home-configurations = import (libExtra.mkFlakePath /home/configurations);
  
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    # Expose flake args to within the nixos config
    inherit
      configname
      hostconfig
      userconfigs
      hosts;
    inherit
      inputs
      outputs
      libExtra;
  };
  modules = [
    # Flake NixOS entrypoint
    host-configurations."${configname}"

    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
    inputs.sops-nix.nixosModules.sops

    {
      # Expose flake args to within the home-manager onfig
      config.home-manager.extraSpecialArgs = {
        inherit
          configname
          hostconfig
          userconfigs
          hosts;
        inherit
          inputs
          outputs
          libExtra;
      };
      config.home-manager.users = inputs.nixpkgs.lib.genAttrs hostconfig.users (
        name: home-configurations.${name}.${configname}
      );
    }
  ];

}
