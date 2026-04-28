{ config, ... }:
let
  commonSecrets = "${config.private.secrets}/home/${config.userInfos.name}/common.yaml";
in
{
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age = {
      keyFile = "/home/${config.userInfos.name}/.config/sops/age/key.txt";
      generateKey = false;
    };
  };
}
