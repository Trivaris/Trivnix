common:
{
  bluetooth.enable = true;
  kde.enable = true;
  openssh.enable = true;
  printing.enable = true;
  gdm.enable = true;
  steam.enable = true;
  sunshine = {
    enableService = true;
    domain = "sunshine.trivaris.org";
  };

  inherit (common) stylix;
}