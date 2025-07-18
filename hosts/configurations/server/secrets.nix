{
  inputs,
  libExtra,
  configname,
  ...
}:
let
  serverSecrets = libExtra.mkFlakePath "/secrets/hosts/${configname}.yaml";
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.secrets = {

  };
}