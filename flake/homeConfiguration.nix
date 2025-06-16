{
  nixpkgs,
  home-manager,
  self,
}:

{
  configname,
  hostname,
  stateVersion,
  architecture ? "x86_64-linux",
  username,
}:

home-manager.lib.homeManagerConfiguration {

  pkgs = nixpkgs.legacyPackages.${architecture};

  # Expose flake args to within the config
  extraSpecialArgs = {
    inherit
      configname
      hostname
      stateVersion
      architecture
      username
      self
      ;
  };

  modules = [
    # Flake entrypoint
    (self + "/home/${username}/${configname}.nix")
  ];

}
