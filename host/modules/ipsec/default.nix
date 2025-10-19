{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.ipsec = import ./options.nix { inherit (lib) mkEnableOption mkOption types; };
  config = mkIf prefs.ipsec.enable {
    assertions = import ./assertions.nix { inherit prefs; };
    vars.extraCertDomains = [ prefs.ipsec.domain ];

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

    environment.etc."ipsec.d/ipsec.secrets" = {
      mode = "0600";
      user = "root";
      group = "root";
      text =
        if prefs.ipsec.asClient then
          "${prefs.ipsec.clientId} : ECDSA ${config.sops.secrets.ipsec-client-key.path}"
        else
          ": ECDSA /etc/ipsec.d/private/${prefs.ipsec.domain}.key.pem";
    };

    services.strongswan = {
      enable = true;
      secrets = [ "/etc/ipsec.d/ipsec.secrets" ];

      setup = {
        strictcrlpolicy = "yes";
        uniqueids = "yes";
      };

      ca.vpn-ca = {
        auto = "add";
        cacert = "/etc/ipsec.d/cacerts/vpn-ca-cert.pem";
        crluri = mkIf (!prefs.ipsec.asClient) "https://${prefs.ipsec.domain}/vpn-ca.crl";
      };

      connections = {
        vpn = mkIf (!prefs.ipsec.asClient) {
          auto = "add";
          type = "tunnel";
          keyexchange = "ikev2";
          ike = "aes256-sha256-modp2048!";
          esp = "aes256-sha256!";

          left = "%any";
          leftcert = "/etc/ipsec.d/certs/${prefs.ipsec.domain}.fullchain.pem";
          leftid = prefs.ipsec.domain;
          leftauth = "pubkey";
          # leftfirewall = "yes";
          # leftsendcert = "yes";
          # leftsubnet = "0.0.0.0/0";

          right = "%any";
          rightauth = "pubkey";
          rightsourceip = "10.0.0.0/24";

          # dpdaction = "clear";
          # dpddelay = "300s";
          # dpdtimeout = "1h";
        };

        vpn-client = mkIf prefs.ipsec.asClient {
          auto = "add";
          type = "tunnel";
          keyexchange = "ikev2";
          ike = "aes256-sha256-modp2048!";
          esp = "aes256-sha256!";

          left = "%any";
          leftid = config.hostPrefs.ipsec.clientId;
          leftcert = config.hostPrefs.ipsec.clientCert;
          leftauth = "pubkey";

          right = config.hostPrefs.ipsec.domain;
          rightid = config.hostPrefs.ipsec.domain;
          rightauth = "pubkey";
          rightsubnet = "0.0.0.0/0,::/0";
        };
      };
    };

    security = mkIf (!prefs.ipsec.asClient) {
      acme.certs.${prefs.ipsec.domain}.postRun = ''
        mkdir -p /etc/ipsec.d/private /etc/ipsec.d/certs
        sudo install -o root -g root -m 0640 /var/lib/acme/${prefs.ipsec.domain}/key.pem /etc/ipsec.d/private/${prefs.ipsec.domain}.key.pem
        sudo install -o root -g root -m 0644 /var/lib/acme/${prefs.ipsec.domain}/fullchain.pem /etc/ipsec.d/certs/${prefs.ipsec.domain}.fullchain.pem
      '';
    };
  };
}
