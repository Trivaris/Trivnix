{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;

  clientCerts = lib.mapAttrs' (
    id: certPath: lib.nameValuePair "ipsec.d/certs/${id}-cert.pem" { source = certPath; }
  ) prefs.ipsecServer.clientCerts;
in
{
  config = lib.mkIf prefs.ipsecServer.enable {
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

    environment.etc = clientCerts // {
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
        client2client = "yes";

        left = "%any";
        leftid = "@${prefs.ipsecServer.domain}";
        leftcert = "/etc/ipsec.d/certs/${prefs.ipsecServer.domain}.fullchain.pem";
        leftauth = "pubkey";
        leftfirewall = "yes";
        leftsubnet = "0.0.0.0/0,::/0";
        leftsourceip = "10.0.0.1";

        right = "%any";
        rightid = "%any";
        rightauth = "pubkey";
        rightsourceip = "10.0.0.0/24";
        rightsubnet = "0.0.0.0/0,::/0";
      };
    };
  };
}
