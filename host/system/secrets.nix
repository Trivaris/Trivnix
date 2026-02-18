{
  config,
  lib,
  pkgs,
  ...
}:
let
  commonSecrets = "${config.private.secrets}/host/common.yaml";
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
  allUserInfos = builtins.mapAttrs (_: cfg: cfg.userInfos) config.home-manager.users;
  prefs = config.hostPrefs;

  perUserSecrets = lib.mapAttrs' (
    user: _:
    lib.nameValuePair "sops-keys/${user}" {
      sopsFile = hostSecrets;
      path = "/home/${user}/.config/sops/age/key.txt";
      owner = user;
      group = "users";
    }
  ) (lib.filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));
in
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops age; };
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = lib.mkMerge [
      perUserSecrets

      {
        ssh-root-key = {
          sopsFile = hostSecrets;
          path = "/root/.ssh/id_ed25519";
          owner = "root";
          group = "root";
        };
      }

      (lib.mkIf prefs.openssh.enable {
        ssh-host-key = {
          sopsFile = hostSecrets;
          path = "/etc/ssh/ssh_host_ed25519_key";
          owner = "root";
          group = "root";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      })

      (lib.mkIf (prefs.reverseProxy.enable || prefs.cfddns.enable) {
        cloudflare-zone-api-token = {
          owner = "root";
          group = "root";
        };

        cloudflare-dns-api-token = {
          owner = "root";
          group = "root";
        };
      })

      (lib.mkIf prefs.openconnectClient.enable {
        openconnect-vpn-password = {
          owner = "root";
          group = "root";
        };
      })

      (lib.mkIf prefs.wireguard.server.enable {
        wireguard-server-key = {
          owner = "root";
          group = "root";
        };
      })

      (lib.mkIf prefs.wireguard.client.enable {
        wireguard-client-key = {
          owner = "root";
          group = "root";
        };
      })

      (lib.mkIf prefs.vaultwarden.enable {
        vaultwarden-admin-token = {
          owner = "vaultwarden";
          group = "vaultwarden";
        };
      })
    ];
  };
}
