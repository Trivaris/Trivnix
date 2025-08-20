{
  inputs,
  outputs,
  trivnixLib,
  commonInfos
}:
{
  configname,
  username
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (trivnixLib) configs;
  
  hostConfig = configs.${configname};
  hostInfos = hostConfig.infos // { inherit configname; };
  hostPrefs = hostConfig.prefs;
  hostPubKeys = hostConfig.pubKeys;

  userConfig = hostConfig.users.${username};
  userInfos = userConfig.infos // { name = username; };
  userPrefs = userConfig.prefs;

  allOtherHostConfigs = builtins.removeAttrs configs [ configname ];
  allOtherUserConfigs = builtins.removeAttrs hostConfig.users [ username ];
  
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
    nameValuePair configname (mapAttrs' (usrname: userconfig:
      nameValuePair usrname (userconfig.infos)
    )(config.users))
  ) allOtherHostConfigs);

  allUserPrefs = mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherUserConfigs;

  allUserInfos = mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherUserConfigs;

  generalArgs = {
    inherit
      inputs
      outputs
      trivnixLib
      commonInfos
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
      hostPrefs
      hostPubKeys
      allUserPrefs
      allUserInfos
      ;
  };

  homeArgs = {
    inherit
      userInfos
      ;
  };
in
homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = hostConfig.infos.architecture;
    overlays = builtins.attrValues (outputs.overlays);
    config = trivnixLib.pkgsConfig;
  };

  extraSpecialArgs = generalArgs // hostArgs // homeArgs;

  modules = [
    # Flake entrypoint
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nvf.homeManagerModules.default

    {
      imports = trivnixLib.resolveDir { dirPath = ./home; preset = "importList"; };

      config = { inherit userPrefs ; };
    }
  ];
}
