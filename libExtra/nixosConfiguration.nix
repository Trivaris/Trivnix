{
  inputs,
  outputs
}:
{
  libExtra,
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
    host-configurations.${configname}

    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.nvf.nixosModules.default

    {
      config.home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.spicetify-nix.homeManagerModules.spicetify
        inputs.nvf.homeManagerModules.default
      ];

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
