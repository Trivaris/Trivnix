{
  config,
  username,
  hostconfig,
  ...
}:
{

  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile = if hostconfig.hardwareKey then [
          config.sops.secrets.ssh-private-key-a.path
          config.sops.secrets.ssh-private-key-c.path
        ] else [
          config.sops.secrets.ssh-private-key.path
        ];
      };

    };
  };

}
