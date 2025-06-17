{ ... }:
{

  imports = [
    ../common
    ../modules
  ];

  config.homeModules = {
    cli-utils = true;
    fish = true;
    vscodium = true;
  };

  config.git.userEmail = "github@tripple.lurdane.de";

}
