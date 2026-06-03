{
  lib,
  config,
  ...
}:
let
  gitPrefs = config.userPrefs.git;
  commonSecrets = "${config.private.secrets}/home/${config.userInfos.name}/common.yaml";
in
{
  config.sops.secrets = lib.mkIf gitPrefs.enableSigning {
    git-signing-key = {
      sopsFile = commonSecrets;
    };
  };
}
