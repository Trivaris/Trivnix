{
  username,
  config,
  ...
}:
{

  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile = [
          config.sops.secrets.ssh-private-key-a.path
          config.sops.secrets.ssh-private-key-c.path
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
