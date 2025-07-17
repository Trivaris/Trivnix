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
    vaultwarden-admin-token = {
      sopsFile = serverSecrets;
      owner = "nginx";
    };
    nextcloud-admin-token = {
      sopsFile = serverSecrets;
      owner = "root";
    };
    cloudflare-api-token = {
      sopsFile = serverSecrets;
      owner = "root";
      group = "nginx";
      mode = "0640";
    };
    cloudflare-api-account-token = {
      sopsFile = serverSecrets;
      owner = "root";
      group = "nginx";
      mode = "0640";
    };
  };
}