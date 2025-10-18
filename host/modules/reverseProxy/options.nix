{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption ''
    Turn on the shared Nginx reverse proxy for modules exposing web services.
    When enabled, any service defining `reverseProxy` will register here.
  '';

  enableDDClient = mkEnableOption ''
    Enable ddclient to update dynamic DNS records for the configured zone.
    Useful when public IPs change and Cloudflare or other providers must sync.
  '';

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
    type = types.port;
    default = 443;

    description = ''
      External port on which Nginx will listen for HTTPS traffic.
      Commonly 443. Make sure this port is forwarded.
    '';
  };

  extraCertDomains = mkOption {
    type = types.listOf types.str;
    default = [ ];

    example = [
      "vpn.example.com"
      "blog.example.com"
    ];

    description = ''
      Additional FQDNs to include in HTTPS Cert generation.
      These do not need to be linked to services managed by this reverse proxy.
    '';
  };

  extraDDNSDomains = mkOption {
    type = types.listOf types.str;
    default = [ ];

    example = [
      "vpn.example.com"
      "blog.example.com"
    ];

    description = ''
      Additional FQDNs to include in DDNS updates.
      These do not need to be linked to services managed by this reverse proxy.
    '';
  };

  ddnsTime = mkOption {
    type = types.nullOr types.str;
    default = null;
    example = "04:00";

    description = ''
      Systemd OnCalendar expression controlling when ddclient runs.
      Leave null to disable the timer or provide values like "daily" or "04:00".
    '';
  };
}
