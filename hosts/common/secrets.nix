{
  pkgs,
  config,
  lib,
  trivnixLib,
  hostInfos,
  allUserInfos,
  ...
}:
let
  commonSecrets = trivnixLib.mkFlakePath "/secrets/hosts/common.yaml";
  hostSecrets = trivnixLib.mkFlakePath "/secrets/hosts/${hostInfos.configname}.yaml";

  cfg = config.hostPrefs;

  perUserSecrets = builtins.concatMap (
    user:
    let
      base = [
        {
          name = "user-passwords/${user}";
          value = {
            neededForUsers = true;
          };
        }
      ];
      extra =
        if (user == "root") then
          [ ]
        else
          [
            {
              name = "sops-keys/${user}";
              value = {
                sopsFile = hostSecrets;
                path = "/home/${user}/.config/sops/age/key.txt";
                owner = user;
                group = "users";
                mode = "0600";
              };
            }
          ];
    in
    base ++ extra
  ) ((builtins.attrNames allUserInfos) ++ [ "root" ]);
in
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      sops
      age
      ;
  };

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
          mode = "0600";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      })

      (lib.mkIf cfg.reverseProxy.enable {
        cloudflare-api-token = {
          owner = "root";
          group = "root";
          mode = "0600";
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
          mode = "0600";
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
