{
  inputs,
  outputs,
  libExtra,
}:
{
  configname,
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair nixosSystem;
  inherit (libExtra) configs;
  
  hostConfig = configs.${configname};
  hostInfo = hostConfig.info // { inherit configname; };
  hostPrefs = hostConfig.prefs;

  allOtherHosts = configs // { ${configname} = null; };
  
  allHostInfos = (mapAttrs' (name: value:
    nameValuePair name (value.info)
  ) allOtherHosts);

  allHostPrefs = (mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherHosts);

  allHostUserPrefs = (mapAttrs' (name: value:
    nameValuePair name (value.users)
  ) allOtherHosts);

  allUserPrefs = mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) hostConfig.users;

  generalArgs = {
    inherit
      inputs
      outputs
      libExtra
      allHostInfos
      allHostPrefs
      allHostUserPrefs
      ;
  };

  hostArgs = {
    inherit 
      hostPrefs
      hostInfo
      allUserPrefs
      ;
  };
in
nixosSystem {
  specialArgs = generalArgs // hostArgs;

  modules = [
    # Flake NixOS entrypoint
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.nvf.nixosModules.default

    hostConfig.partitions
    hostConfig.hardware

    {
      # Expose flake args to within the home-manager config
      config.home-manager = {
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.spicetify-nix.homeManagerModules.spicetify
          inputs.nvf.homeManagerModules.default
        ];
        
        users = mapAttrs' (name: userPrefs:
          nameValuePair
          name
          (
            { libExtra, ... }:
            {
              imports = [
                (libExtra.mkFlakePath /home/common)
                (libExtra.mkFlakePath /home/modules)
              ];
              
              home-manager.extraSpecialArgs = {
                userPrefs = userPrefs // {
                  inherit name;
                };
              };
            }
          )
        ) allUserPrefs;
      };
    }
  ];

}
