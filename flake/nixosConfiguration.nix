{
  inputs,
  outputs,
  nixpkgs,
  disko,
  sops-nix,
  home-manager,
  nixos-wsl,
  libExtra,
  ...
}:
{
  configname,
  hostname,
  stateVersion,
  hardwareKey,
  hosts,
  users,
  architecture ? "x86_64-linux",
  usernames ? [ "trivaris" ],
}:
let
  host-configurations = import (libExtra.mkFlakePath /hosts/configurations);
  home-configurations = import (libExtra.mkFlakePath /home/configurations);
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    # Expose flake args to within the nixos config
    inherit
      inputs
      outputs
      hostname
      stateVersion
      hardwareKey
      hosts
      users
      configname
      architecture
      libExtra
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
          hardwareKey
          hosts
          users
          architecture
          libExtra
          ;
      };
      # Flake Home Manager entrypoint
      config.home-manager.users = nixpkgs.lib.genAttrs usernames (
        name: home-configurations.${name}.${configname}
      );
    }
  ];

}
