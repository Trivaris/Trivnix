{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        addKeysToAgent = "no";
        identityFile = [
          config.sops.secrets.ssh-private-key.path
        ];
      };
    };
  };
}
