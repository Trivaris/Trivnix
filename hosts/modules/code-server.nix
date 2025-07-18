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
      default = 8888;
      description = "Internal Port used by the reverse Proxy";
    };

    domain = mkOption {
      type = types.str;
      description = "DNS name";
    };
  };

  config = mkIf cfg.codeServer.enable {
    services.code-server = {
      enable = true;
      # disableTelemetry = true;
      port = cfg.codeServer.port;
      host = "127.0.0.1";
      user = "trivaris";
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
    
}
