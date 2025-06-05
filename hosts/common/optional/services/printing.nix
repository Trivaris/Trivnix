
{ pkgs, ... }:
{

  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };

  systemd.services.cups-browsed = {
    enable = false;
    unitConfig.Mask = true;
  };
  
}