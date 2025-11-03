{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.ipsecClient.enable {
    environment.etc."ipsec.d/ipsec.secrets" = {
      mode = "0600";
      user = "root";
      group = "root";
      text = ''
        @${prefs.ipsecClient.id}.${prefs.ipsecClient.domain} : ECDSA ${config.sops.secrets.ipsec-client-key.path}
      '';
    };

    services.strongswan = {
      enable = true;
      secrets = [ "/etc/ipsec.d/ipsec.secrets" ];
      setup.uniqueids = "no";

      ca.vpn-ca = {
        auto = "add";
        cacert = prefs.ipsecClient.caCert;
      };

      connections.vpn = {
        auto = "add";
        type = "tunnel";
        keyexchange = "ikev2";
        ike = "aes256-sha256-modp2048!";
        esp = "aes256-sha256!";

        left = "%any";
        leftid = "@${prefs.ipsecClient.id}.${prefs.ipsecClient.domain}";
        leftcert = prefs.ipsecClient.cert;
        leftauth = "pubkey";
        leftsourceip = "%config";

        right = prefs.ipsecClient.domain;
        rightid = "@${prefs.ipsecClient.domain}";
        rightauth = "pubkey";
      };
    };
  };
}
