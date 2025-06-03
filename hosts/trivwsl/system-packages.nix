{
  pkgs,
  ...
}:
{

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
    allowSFTP = true;
    openFirewall = false;
  };

}
