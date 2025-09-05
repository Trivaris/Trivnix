{
  inputs,
  outputs,
  trivnixLib,
  commonInfos,
  configs,
  inputOverlays,
}:
{
  configname,
  username,
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  hostConfig = configs.${configname};
  hostPrefs = hostConfig.prefs;
  hostPubKeys = hostConfig.pubKeys;
  userConfig = hostConfig.users.${username};
  userPrefs = userConfig.prefs;
  allOtherHostConfigs = builtins.removeAttrs configs [ configname ];
  allOtherUserConfigs = builtins.removeAttrs hostConfig.users [ username ];
  allHostInfos = mapAttrs' (name: value: nameValuePair name value.infos) allOtherHostConfigs;
  allHostPrefs = mapAttrs' (name: value: nameValuePair name value.prefs) allOtherHostConfigs;
  allHostPubKeys = mapAttrs' (name: value: nameValuePair name value.pubKeys) allOtherHostConfigs;
  allUserPrefs = mapAttrs' (name: value: nameValuePair name value.prefs) allOtherUserConfigs;
  allUserInfos = mapAttrs' (name: value: nameValuePair name value.prefs) allOtherUserConfigs;

  hostInfos = hostConfig.infos // {
    inherit configname;
  };

  userInfos = userConfig.infos // {
    name = username;
  };

  allHostUserPrefs = mapAttrs' (
    configname: config:
    nameValuePair configname (
      mapAttrs' (usrname: userconfig: nameValuePair usrname userconfig.prefs) config.users
    )
  ) allOtherHostConfigs;

  allHostUserInfos = mapAttrs' (
    configname: config:
    nameValuePair configname (
      mapAttrs' (usrname: userconfig: nameValuePair usrname userconfig.infos) config.users
    )
  ) allOtherHostConfigs;

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
  extraSpecialArgs = generalArgs // hostArgs // homeArgs;

  pkgs = import inputs.nixpkgs {
    system = hostConfig.infos.architecture;
    overlays = builtins.attrValues (inputOverlays // outputs.overlays);
    config = hostConfig.pkgsConfig;
  };

  modules = [
    # Flake entrypoint
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nvf.homeManagerModules.default

    {
      config = { inherit userPrefs; };

      imports = trivnixLib.resolveDir {
        dirPath = ./home;
        preset = "importList";
      };
    }
  ];
}
