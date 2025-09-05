{
  inputs,
  outputs,
  trivnixLib,
  configs,
  commonInfos,
  inputOverlays,
}:
{
  configname,
}:
let
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair nixosSystem;

  hostConfig = configs.${configname};
  hostPrefs = hostConfig.prefs;
  hostPubKeys = hostConfig.pubKeys;
  allOtherHostConfigs = removeAttrs configs [ configname ];
  allHostInfos = mapAttrs' (name: value: nameValuePair name value.infos) allOtherHostConfigs;
  allHostPrefs = mapAttrs' (name: value: nameValuePair name value.prefs) allOtherHostConfigs;
  allHostPubKeys = mapAttrs' (name: value: nameValuePair name value.pubKeys) allOtherHostConfigs;
  allUserPrefs = mapAttrs' (name: value: nameValuePair name value.prefs) hostConfig.users;
  allUserInfos = mapAttrs' (name: value: nameValuePair name value.infos) hostConfig.users;

  hostInfos = hostConfig.infos // {
    inherit configname;
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
      hostPubKeys
      allUserPrefs
      allUserInfos
      ;
  };

  pkgs = import inputs.nixpkgs {
    system = hostConfig.infos.architecture;
    overlays = builtins.attrValues (inputOverlays // outputs.overlays);
    config = hostConfig.pkgsConfig;
  };
in
nixosSystem {
  inherit pkgs;
  specialArgs = generalArgs // hostArgs;

  modules = [
    # Flake NixOS entrypoint
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.spicetify-nix.nixosModules.spicetify
    inputs.nvf.nixosModules.default
    hostConfig.partitions
    hostConfig.hardware

    {
      imports = trivnixLib.resolveDir {
        dirPath = ./host;
        preset = "importList";
      };

      # Expose flake args, also within the home-manager config
      config = {
        inherit hostPrefs;
        disko.enableConfig = true;

        home-manager = {
          sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.nvf.homeManagerModules.default
          ];

          extraSpecialArgs = generalArgs // hostArgs // { inherit hostPrefs pkgs; };
          useUserPackages = true;

          users = mapAttrs' (
            name: userPrefs:
            let
              userInfos = hostConfig.users.${name}.infos // {
                inherit name;
              };
            in
            nameValuePair name {
              imports =
                trivnixLib.resolveDir {
                  dirPath = ./home;
                  preset = "importList";
                }
                ++ [
                  { _module.args = { inherit userInfos; }; }
                ];

              config = { inherit userPrefs; };
            }
          ) allUserPrefs;
        };
      };
    }
  ];

}
