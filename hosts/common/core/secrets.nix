{ inputs, pkgs, ... }:
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${inputs.self}/resources/secrets.yaml";
    validateSopsFiles = false;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "user-passwords/trivaris" = {
        neededForUsers = true;
      };
      "user-passwords/root" = {
        neededForUsers = true;
      };
    };
  };

}
