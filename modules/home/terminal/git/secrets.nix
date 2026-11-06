{
  flake.homeModules.terminal-git =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      git-prefs = config.user-prefs.git;
      common-secrets = "${osConfig.private.secrets}/home/${config.home.username}/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf git-prefs.enableSigning {
        git-signing-key = {
          sopsFile = common-secrets;
        };
      };
    };
}
