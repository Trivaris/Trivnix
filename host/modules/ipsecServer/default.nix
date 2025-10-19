{
  allHostPrefs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mapAttrs'
    mkIf
    nameValuePair
    ;

  prefs = config.hostPrefs;

  clientCerts = mapAttrs' (
    _: client:
    nameValuePair "ipsec.d/certs/${client.ipsecClient.id}-cert.pem" {
      source = client.ipsecClient.cert;
    }
  ) ((filterAttrs (_: hPrefs: hPrefs.ipsecClient.enable or false)) allHostPrefs);

  extraClientCerts = mapAttrs' (
    id: path: nameValuePair "ipsec.d/certs/${id}-cert.pem" { source = path; }
  ) prefs.ipsecServer.extraClientCerts;
in
{
  options.hostPrefs.ipsecServer = import ./options.nix {
    inherit (lib) mkEnableOption mkOption types;
  };

  config = mkIf prefs.ipsecServer.enable {
    assertions = import ./assertions.nix { inherit prefs; };

    networking.firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [
        500
        4500
      ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    environment.etc =
      clientCerts
      // extraClientCerts
      // {
        "ipsec.d/ipsec.secrets" = {
          mode = "0600";
          text = ''
            : ECDSA ${config.sops.secrets.ipsec-server-key.path}
          '';
        };

        "ipsec.d/certs/${prefs.ipsecServer.domain}.fullchain.pem" = {
          mode = "0600";
          source = prefs.ipsecServer.fullchain;
        };
      };

    services.strongswan = {
      enable = true;
      secrets = [ "/etc/ipsec.d/ipsec.secrets" ];
      setup.uniqueids = "no";

      ca.vpn-ca = {
        auto = "add";
        cacert = prefs.ipsecServer.caCert;
      };

      connections.vpn = {
        auto = "add";
        type = "tunnel";
        keyexchange = "ikev2";
        ike = "aes256-sha256-modp2048!";
        esp = "aes256-sha256!";
        dpdaction = "clear";
        dpddelay = "30s";

        left = "%any";
        leftid = "@${prefs.ipsecServer.domain}";
        leftcert = "/etc/ipsec.d/certs/${prefs.ipsecServer.domain}.fullchain.pem";
        leftauth = "pubkey";
        leftfirewall = "yes";
        leftsubnet = "10.0.0.1/24";

        right = "%any";
        rightid = "%any";
        rightauth = "pubkey";
        rightsourceip = "10.0.0.0/24";
        rightsubnet = "0.0.0.0/0,::/0";
      };
    };
  };
}
