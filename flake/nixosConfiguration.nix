{
  nixpkgs,
  disko,
  sops-nix,
  home-manager,
  nixos-wsl,
  self,
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
      configname
      hostname
      stateVersion
      architecture
      self
      ;
    usernames = usernames ++ [ "root" ];
  };
  modules = [
    # Flake entrypoint
    (self + "/hosts/${configname}")

    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    nixos-wsl.nixosModules.default
    sops-nix.nixosModules.sops

    {
      # Expose flake args to within the home-manager onfig
      config.home-manager.extraSpecialArgs = {
        inherit
          configname
          hostname
          stateVersion
          architecture
          self
          ;
      };
    }
  ];

}
