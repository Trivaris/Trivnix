{
  flake.homeModules.terminal-git =
    {
      lib,
      config,
      ...
    }:
    let
      gitPreferences = config.user.preferences.git;
    in
    {
      config.sops.secrets = lib.mkIf gitPreferences.enableSigning {
        git-signing-key = {
          sopsFile = config.user.private.secrets.commonSecretsFile;
        };
      };
    };
}
