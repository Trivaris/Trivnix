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
    mapAttrs'
    nameValuePair
    filterAttrs
    mkIf
    mkMerge
    ;

  hasPrivate = inputs ? trivnixPrivate;
  private = if hasPrivate then inputs.trivnixPrivate else { };
  hasWireguard =
    hasPrivate && (private ? wireguardInterfaces) && builtins.isAttrs private.wireguardInterfaces;

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
      mode = "0600";
    }
  ) (filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));

  wireguardSecrets = mapAttrs' (
    interface: _:
    nameValuePair "wireguard-preshared-keys/${interface}" {
      owner = "root";
      group = "root";
      mode = "0600";
    }
  ) private.wireguardInterfaces;
in
{
  assertions = [
    {
      assertion = hasPrivate;
      message = ''
        Missing input "trivnixPrivate". Provide your private flake or override the input.
        See docs/trivnix-private.md and use: nix build --override-input trivnixPrivate <your_repo>
      '';
    }
    {
      assertion = hasWireguard || (!prefs.wireguard.enable);
      message = ''Invalid or missing inputs.trivnixPrivate.wireguardInterfaces (expected attrset) while hostPrefs.wireguard.enable = true.'';
    }
  ];

  environment.systemPackages = builtins.attrValues { inherit (pkgs) sops age; };
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = mkMerge [
      perUserSecrets
      wireguardSecrets

      {
        ssh-root-key = {
          sopsFile = hostSecrets;
          path = "/root/.ssh/id_ed25519";
          owner = "root";
          group = "root";
          mode = "0600";
        };
      }

      (mkIf prefs.openssh.enable {
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

      (mkIf prefs.wireguard.enable {
        wireguard-client-key = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
          mode = "0600";
        };
      })

      (mkIf prefs.reverseProxy.enable {
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

      (mkIf prefs.nextcloud.enable {
        nextcloud-admin-token = {
          owner = "nextcloud";
          group = "nextcloud";
          mode = "0600";
        };
      })

      (mkIf prefs.suwayomi.enable {
        suwayomi-webui-password = {
          owner = "suwayomi";
          group = "suwayomi";
          mode = "0600";
        };
      })

      (mkIf prefs.vaultwarden.enable {
        vaultwarden-admin-token = {
          owner = "vaultwarden";
          group = "vaultwarden";
          mode = "0600";
        };
      })
    ];
  };
}
