{
  inputs,
  outputs,
  libExtra,
}:
{
  configname,
  username
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (libExtra) configs;
  
  hostConfig = configs.${configname};
  hostInfo = hostConfig.info // { inherit configname; };
  hostPrefs = hostConfig.prefs;

  allOtherHostConfigs = configs // { ${configname} = null; };
  allOtherUserConfigs = hostConfig.users // { ${configname} = null; };
  
  allHostInfos = (mapAttrs' (name: value:
    nameValuePair name (value.info)
  ) allOtherHostConfigs);

  allHostPrefs = (mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherHostConfigs);

  allHostUserPrefs = (mapAttrs' (name: value:
    nameValuePair name (value.users)
  ) allOtherHostConfigs);


  allUserPrefs = mapAttrs' (name: value:
    nameValuePair name (value.prefs)
  ) allOtherUserConfigs;

  userPrefs = hostConfig.users.${username};

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

  homeArgs = {
    inherit userPrefs;
  };
in
homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = hostConfig.info.architecture;
    overlays = builtins.attrValues (outputs.overlays);
    config = libExtra.pkgsConfig;
  };

  extraSpecialArgs = generalArgs // hostArgs // homeArgs;

  modules = [
    # Flake entrypoint
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nvf.homeManagerModules.default

    (
      { libExtra, ... }:
      {
        imports = [
          (libExtra.mkFlakePath /home/common)
          (libExtra.mkFlakePath /home/modules)
        ];

        inherit userPrefs;
      }
    )
  ];
}
