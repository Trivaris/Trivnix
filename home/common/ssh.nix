{
  username,
  ...
}:
{

  programs.ssh = {
    addKeysToAgent = "yes";

    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
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
