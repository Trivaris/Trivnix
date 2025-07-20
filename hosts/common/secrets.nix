{
  inputs,
  pkgs,
  config,
  lib,
  libExtra,
  configname,
  hostconfig,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath /secrets/hosts/common.yaml;
  hostSecrets = libExtra.mkFlakePath "/secrets/hosts/${configname}.yaml";

  cfg = config.nixosModules;

  perUserSecrets = builtins.concatMap (user:
    let
      base = [{
        name = "user-passwords/${user}";
        value = {
          neededForUsers = true;
        };
      }];
      extra = if user == "root" then [] else [{
        name = "sops-keys/${user}";
        value = {
          sopsFile = hostSecrets;
          path = "/home/${user}/.config/sops/age/keys.txt";
          owner = user;
          group = "users";
          mode = "0600";
        };
      }];
    in base ++ extra
  ) (hostconfig.users ++ [ "root" ]);
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
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = lib.mkMerge [
      (builtins.listToAttrs perUserSecrets)

      (lib.mkIf cfg.openssh.enable {
        ssh-host-key = {
          sopsFile = hostSecrets;
          path = "/etc/ssh/ssh_host_ed25519_key";
          owner = "root";
          group = "root";
          mode = "0640";
          restartUnits = [ "sshd.service" ];
        };
      })

      (lib.mkIf cfg.reverseProxy.enable {
        cloudflare-api-token = {
          owner = "root";
          group = "root";
          mode = "0640";
        };

        cloudflare-api-account-token = {
          owner = "root";
          group = "root";
          mode = "0600";
        };
      })

      (lib.mkIf cfg.nextcloud.enable {
        nextcloud-admin-token = {
          owner = "nextcloud";
          group = "nextcloud";
          mode = "0640";
        };
      })

      (lib.mkIf cfg.suwayomi.enable {
        suwayomi-webui-password = {
          owner = "suwayomi";
          group = "suwayomi";
          mode = "0600";
        };
      })
    ];
  };

}
