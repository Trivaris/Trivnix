{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
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
