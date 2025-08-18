{
  inputs,
  outputs,
  trivnixLib,
  configs,
}:
{
  configname,
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair nixosSystem;
  
  hostConfig = configs.${configname};
  hostInfos = hostConfig.infos // { inherit configname; };
  hostPrefs = hostConfig.prefs;
  hostPubKeys = hostConfig.pubKeys;

  allOtherHostConfigs = builtins.removeAttrs configs [ configname ];

  allHostInfos = (mapAttrs' (name: value:
    nameValuePair name (value.infos)
  ) allOtherHostConfigs);

  allHostPrefs = (mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherHostConfigs);

  allHostPubKeys = (mapAttrs' (name: value:
    nameValuePair name (value.pubKeys)
  ) allOtherHostConfigs);

  allHostUserPrefs = (mapAttrs' (configname: config:
    nameValuePair configname (mapAttrs' (usrname: userconfig:
      nameValuePair usrname (userconfig.prefs)
    )(config.users))
  ) allOtherHostConfigs);

  allHostUserInfos = (mapAttrs' (configname: config:
    nameValuePair configname ( mapAttrs'(usrname: userconfig:
      nameValuePair usrname (userconfig.infos)
    )(config.users))
  ) allOtherHostConfigs);

  allUserPrefs = mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) hostConfig.users;

  allUserInfos = mapAttrs' (name: value:
    nameValuePair name (value.infos)
  ) hostConfig.users;

  generalArgs = {
    inherit
      inputs
      outputs
      trivnixLib
      allHostInfos
      allHostPrefs
      allHostPubKeys
      allHostUserPrefs
      allHostUserInfos
      ;
  };

  hostArgs = {
    inherit 
      hostInfos
      hostPubKeys
      allUserPrefs
      allUserInfos
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
      imports = trivnixLib.resolveDir { dirPath = ./hosts; preset = "importList"; };
      config = { inherit hostPrefs; };
      config.disko.enableConfig = true;

      # Expose flake args to within the home-manager config
      config.home-manager = {
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.spicetify-nix.homeManagerModules.spicetify
          inputs.nvf.homeManagerModules.default
        ];

        extraSpecialArgs = generalArgs // hostArgs;
        
        users = mapAttrs' (name: userPrefs:
          let
            userInfos = hostConfig.users.${name}.infos // { inherit name; };
          in
          nameValuePair
          name
          {
            imports = trivnixLib.resolveDir { dirPath = ./home; preset = "importList"; } ++ [
              { _module.args = { inherit userInfos; }; }
            ];

            config = { inherit userPrefs; };
          }
        ) allUserPrefs;
      };
    }
  ];

}
