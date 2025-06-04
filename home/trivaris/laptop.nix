{ ... }:
{

  imports = [
    ../common/themes/material-green.nix
    ./secrets.nix
    ./home.nix
    ./credentials.nix
    ./programs
  ];

}
