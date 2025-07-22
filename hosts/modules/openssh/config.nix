lib:
with lib;
{
  enable = mkEnableOption "OpenSSH Server";

  ports = mkOption {
    type = types.listOf types.int;
    default = [ 22 ];
    description = ''
      TCP port the OpenSSH daemon will listen on.
      Ensure this port is allowed through the firewall if accessing remotely.
    '';
  };
}