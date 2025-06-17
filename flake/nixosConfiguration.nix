{
  inputs,
  outputs,
  nixpkgs,
  disko,
  sops-nix,
  home-manager,
  nixos-wsl,
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
      ;
    usernames = usernames ++ [ "root" ];
  };
  modules = [
    # Flake entrypoint
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
          ;
      };
    }
  ];

}
