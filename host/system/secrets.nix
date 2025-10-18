{
  config,
  lib,
  pkgs,
  inputs,
  allUserInfos,
  hostInfos,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mapAttrs'
    mkIf
    mkMerge
    nameValuePair
    ;

  commonSecrets = "${inputs.trivnixPrivate.secrets}/host/common.yaml";
  hostSecrets = "${inputs.trivnixPrivate.secrets}/host/${hostInfos.configname}.yaml";
  prefs = config.hostPrefs;

  perUserSecrets = mapAttrs' (
    user: _:
    nameValuePair "sops-keys/${user}" {
      sopsFile = hostSecrets;
      path = "/home/${user}/.config/sops/age/key.txt";
      owner = user;
      group = "users";
    }
  ) (filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));
in
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops age; };
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = mkMerge [
      perUserSecrets

      {
        ssh-root-key = {
          sopsFile = hostSecrets;
          path = "/root/.ssh/id_ed25519";
          owner = "root";
          group = "root";
        };
      }

      (mkIf prefs.wireguard.enable {
        wg-server-key = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
        };
      })

      (mkIf prefs.openssh.enable {
        ssh-host-key = {
          sopsFile = hostSecrets;
          path = "/etc/ssh/ssh_host_ed25519_key";
          owner = "root";
          group = "root";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      })

      (mkIf prefs.reverseProxy.enable {
        cloudflare-api-token = {
          owner = "root";
          group = "root";
        };

        cloudflare-api-account-token = {
          owner = "root";
          group = "root";
        };
      })

      (mkIf prefs.nextcloud.enable {
        nextcloud-admin-token = {
          owner = "nextcloud";
          group = "nextcloud";
        };
      })

      (mkIf prefs.suwayomi.enable {
        suwayomi-webui-password = {
          inherit (config.suwayomi-server) group;
          owner = config.suwayomi-server.user;
        };
      })

      (mkIf prefs.vaultwarden.enable {
        vaultwarden-admin-token = {
          owner = "vaultwarden";
          group = "vaultwarden";
        };
      })
    ];
  };
}
