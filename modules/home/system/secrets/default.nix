{ inputs, ... }:
{
  flake.homeModules.system-secrets =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      sops = {
        validateSopsFiles = true;

        age = {
          keyFile = "/home/${config.userInfos.name}/.config/sops/age/key.txt";
          generateKey = false;
        };
      };
    };
}
