{
  inputs,
  libExtra,
  configname,
  ...
}:
let
  laptopSecrets = libExtra.mkFlakePath "/secrets/hosts/${configname}.yaml";
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.secrets = {
    code-server-password = {
      sopsFile = laptopSecrets;
      owner = "code-server";
    };
  };
}
