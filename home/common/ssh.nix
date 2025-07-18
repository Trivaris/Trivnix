{
  username,
  config,
  hardwareKey,
  ...
}:
{

  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile = if hardwareKey then [
          config.sops.secrets.ssh-private-key-a.path
          config.sops.secrets.ssh-private-key-c.path
        ] else [
          config.sops.secrets.ssh-private-key.path
        ];
      };

      desktop = {
        host = "192.168.178.70";
        user = username;
      };

      laptop = {
        host = "192.168.178.90";
        user = username;
      };

      wsl = {
        host = "192.168.178.70";
        user = username;
        port = 2222;
      };
    };
  };

}
