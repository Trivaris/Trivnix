{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.codeServer = {
    enable = mkEnableOption "Code Server";
    port = mkOption {
      type = types.int;
      description = "Port of codeserver";
    };
    domain = mkOption {
      type = types.str;
      description = "DNS name of codeserver";
    };
    email = mkOption {
      type = types.str;
      description = "Email for expiry reminders";
    };
  };

  config = mkIf cfg.codeServer.enable {

    networking.firewall.allowedTCPPorts = [ cfg.codeServer.port ];

    services.code-server = {
      enable = true;
      disableTelemetry = true;
      host = cfg.codeServer.domain;
      port = cfg.codeServer.port;
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
    
}
