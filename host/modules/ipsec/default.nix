{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkForce mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.ipsec = import ./options.nix {
    inherit (lib) mkEnableOption mkOption types;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.ipsec.enable {
    hostPrefs.ipsec.reverseProxy.enable = mkForce false;

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

    services.strongswan = {
      enable = true;
      secrets = [ config.sops.secrets.ipsec-user-config.path ];

      connections = {
        "%default" = {
          keyexchange = "ikev2";
          ike = "aes256-sha256-modp2048";
          esp = "aes256-sha256";
          leftfirewall = "yes";
        };

        "ikev2-eap" = {
          auto = "add";
          left = "%any";
          leftcert = "/etc/ipsec.d/certs/${prefs.ipsec.reverseProxy.domain}.fullchain.pem";
          leftid = prefs.ipsec.reverseProxy.domain;
          leftsubnet = "0.0.0.0/0,::/0";
          right = "%any";
          rightsourceip = "10.10.10.0/24,fd00:10:10::/64";
          rightauth = "eap-mschapv2";
          eap_identity = "%identity";
        };
      };

      setup = {
        charondebug = "ike 1, knl 1, cfg 0";
        uniqueids = "replace";
        strictcrlpolicy = "yes";
      };
    };

    security.acme.certs.${prefs.ipsec.reverseProxy.domain}.postRun = ''
      install -o root -g root -m 0640 /var/lib/acme/${prefs.ipsec.reverseProxy.domain}/key.pem /etc/ipsec.d/private/${prefs.ipsec.reverseProxy.domain}.key.pem
      install -o root -g root -m 0644 /var/lib/acme/${prefs.ipsec.reverseProxy.domain}/fullchain.pem /etc/ipsec.d/certs/${prefs.ipsec.reverseProxy.domain}.fullchain.pem
    '';
  };
}
