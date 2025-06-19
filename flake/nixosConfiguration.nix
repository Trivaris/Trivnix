{
  inputs,
  outputs,
  nixpkgs,
  disko,
  sops-nix,
  home-manager,
  nixos-wsl,
  pkgsLib,
  ...
}:
{
  configname,
  hostname,
  stateVersion,
  architecture ? "x86_64-linux",
  usernames ? [ "trivaris" ],
}:
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
      pkgsLib
      ;
    usernames = usernames ++ [ "root" ];
  };
  modules = [
    # Flake NixOS entrypoint
    (inputs.self + "/hosts/${configname}")

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
          pkgsLib
          ;
      };
      # Flake Home Manager entrypoint
      config.home-manager.users = nixpkgs.lib.genAttrs usernames (name:
        import (inputs.self + "/home/${name}/${configname}.nix")
      );
    }
  ];

}
