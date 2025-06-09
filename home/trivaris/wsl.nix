{ ... }:
{

  imports = [ 
    ../common
    ./credentials.nix
  ];

  config.modules = {
    cli-utils = true;
    fish = true;
  };

}
