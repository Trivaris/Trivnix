{
  inputs,
  pkgs,
  usernames,
  configname,
  libExtra,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath /secrets/hosts/common.yaml;
  hostSecrets = libExtra.mkFlakePath "/secrets/hosts/${configname}.yaml";

  perUserSecrets = builtins.concatLists (
    builtins.map (
      user:
      [
        {
          name = "user-passwords/${user}";
          value = {
            neededForUsers = true;
            sopsFile = commonSecrets;
          };
        }
      ]
      ++ (
        if user == "root" then
          [ ]
        else
          [
            {
              name = "sops-keys/${user}";
              value = {
                path = "/home/${user}/.config/sops/age/keys.txt";
                owner = user;
                group = "users";
                mode = "0600";
              };
            }
          ]
      )
    ) usernames
  );
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = hostSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = builtins.listToAttrs perUserSecrets // {
      ssh-host-key = {
        path = "/etc/ssh/ssh_host_ed25519_key";
        owner = "root";
        group = "root";
        mode = "0600";
        restartUnits = [ "sshd.service" ];
      };
    };
  };

}
