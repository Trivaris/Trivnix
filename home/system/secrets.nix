{ config, ... }:
{
  sops = {
    validateSopsFiles = true;

    age = {
      keyFile = "/home/${config.userInfos.name}/.config/sops/age/key.txt";
      generateKey = false;
    };
  };
}
