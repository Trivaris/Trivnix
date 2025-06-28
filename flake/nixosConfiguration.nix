{
  inputs,
  outputs,
  nixpkgs,
  disko,
  sops-nix,
  home-manager,
  nixos-wsl,
  lib-extra,
  ...
}:
{
  configname,
  hostname,
  stateVersion,
  architecture ? "x86_64-linux",
  usernames ? [ "trivaris" ],
}:
let
  host-configurations = import (lib-extra.mkFlakePath /hosts/configurations);
  home-configurations = import (lib-extra.mkFlakePath /home/configurations);
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    # Expose flake args to within the nixos config
    inherit
      inputs
      outputs
      hostname
      stateVersion
      configname
      architecture
      lib-extra
      ;
    usernames = usernames ++ [ "root" ];
  };
  modules = [
    # Flake NixOS entrypoint
    host-configurations."${configname}"

    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    nixos-wsl.nixosModules.default
    sops-nix.nixosModules.sops

    {
      # Expose flake args to within the home-manager onfig
      config.home-manager.extraSpecialArgs = {
        inherit
          inputs
          outputs
          configname
          hostname
          stateVersion
          architecture
          lib-extra
          ;
      };
      # Flake Home Manager entrypoint
      config.home-manager.users = nixpkgs.lib.genAttrs usernames (
        name: home-configurations.${name}.${configname}
      );
    }
  ];

}
