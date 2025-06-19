{
  inputs,
  outputs,
  home-manager,
  pkgsLib,
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

  pkgs = pkgsLib.mkPkgs architecture;

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
      pkgsLib
      ;
  };

  modules = [
    # Flake entrypoint
    (inputs.self + "/home/${username}/${configname}.nix")
  ];

}
