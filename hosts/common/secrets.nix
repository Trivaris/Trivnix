{
  inputs,
  pkgs,
  config,
  lib,
  trivnixLib,
  hostInfos,
  allUserInfos,
  ...
}:
let
  commonSecrets = trivnixLib.mkStorePath "secrets/hosts/common.yaml";
  hostSecrets = trivnixLib.mkStorePath "secrets/hosts/${hostInfos.configname}.yaml";

  prefs = config.hostPrefs;

  perUserSecrets = lib.mapAttrs' (user: _: lib.nameValuePair
    "sops-keys/${user}"
    {
      sopsFile = hostSecrets;
      path = "/home/${user}/.config/sops/age/key.txt";
      owner = user;
      group = "users";
      mode = "0600";
    }
  ) (lib.filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));

  wireguardSecrets = lib.mapAttrs' (interface: _: lib.nameValuePair
    "wireguard-preshared-keys/${interface}"
    {
      owner = "root";
      group = "root";
      mode = "0600";
    }
  ) inputs.trivnix-private.wireguardInterfaces;
in
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) sops age;
  };

  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = (lib.mkMerge [
      perUserSecrets
      wireguardSecrets

      (lib.mkIf prefs.openssh.enable {
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

      (lib.mkIf prefs.wireguard.enable {
        wireguard-client-key = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
          mode = "0600";
        };
      })

      (lib.mkIf prefs.reverseProxy.enable {
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

      (lib.mkIf prefs.nextcloud.enable {
        nextcloud-admin-token = {
          owner = "nextcloud";
          group = "nextcloud";
          mode = "0600";
        };
      })

      (lib.mkIf prefs.suwayomi.enable {
        suwayomi-webui-password = {
          owner = "suwayomi";
          group = "suwayomi";
          mode = "0600";
        };
      })
    ]);
  };

}
