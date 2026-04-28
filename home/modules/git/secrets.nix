{
  lib,
  config,
  ...
}:
let 
  gitPrefs = config.userPrefs.git;
in
{
  config.sops.secrets = lib.mkIf gitPrefs.enableSigning {
    git-signing-key = { };
  };
}