{
  pkgs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops age; };
  sops = {
    validateSopsFiles = true;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
  };
}
