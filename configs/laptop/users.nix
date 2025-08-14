common:
{
  trivaris = {
    infos = { };
    prefs = {
      email.enable = true;
      lutris.enable = true;
      vscodium.enableLsp = true;
      fish.enable = true;

      git.email = "github@tripple.lurdane.de";

      inherit (common) librewolf desktopApps extendedCli;
    };
  };
}