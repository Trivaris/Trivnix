lib:
with lib;
{
  enable = mkEnableOption "Enable reverse proxy for all enabled services.";

  email = mkOption {
    type = types.str;
    example = "admin@example.com";
    description = ''
      Email address used for Let's Encrypt/ACME certificate requests.
      Required for domain validation and renewal notices.
    '';
  };

  zone = mkOption {
    type = types.str;
    example = "example.com";
    description = ''
      The DNS zone managed by Cloudflare (e.g., your root domain).
      This is used to determine which domain records DDNS will update.
    '';
  };

  port = mkOption {
    type = types.int;
    default = 443;
    description = ''
      External port on which Nginx will listen for HTTPS traffic.
      Commonly 443. Make sure this port is forwarded.
    '';
  };

  extraDomains = mkOption {
    type = types.listOf types.str;
    default = [];
    example = [ "vpn.example.com" "blog.example.com" ];
    description = ''
      Additional FQDNs to include in DDNS updates.
      These do not need to be linked to services managed by this reverse proxy.
    '';
  };
  
  ddnsTime = mkOption {
    type = types.str;
    example = "04:00";
    description = ''
      Systemd OnCalendar timestamp to schedule DDNS updates with ddclient.
      Follows systemd time syntax. Examples:
        - "daily"
        - "04:00"
        - "Mon *-*-* 02:00:00"
    '';
  };
}