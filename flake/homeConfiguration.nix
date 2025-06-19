{
  inputs,
  outputs,
  nixpkgs,
  home-manager,
  ...
}:

{
  configname,
  hostname,
  stateVersion,
  architecture ? "x86_64-linux",
  username,
}:

home-manager.lib.homeManagerConfiguration {

  pkgs = outputs.mkPkgs architecture;

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
      ;
  };

  modules = [
    # Flake entrypoint
    (inputs.self + "/home/${username}/${configname}.nix")
  ];

}
