{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops age; };
  sops = {
    defaultSopsFile = "${config.private.secrets}/host/common.yaml";
    validateSopsFiles = true;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
  };
}
