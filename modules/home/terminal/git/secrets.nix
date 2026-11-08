{
  flake.homeModules.terminal-git =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      gitPreferences = config.user.preferences.git;
      commonSecrets = "${osConfig.private.secrets}/home/${config.home.username}/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf gitPreferences.enableSigning {
        git-signing-key = {
          sopsFile = commonSecrets;
        };
      };
    };
}
