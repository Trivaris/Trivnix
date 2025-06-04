{ ... }:
{

  imports = [
    ../common/themes/material-green.nix
    ./home.nix
    ./secrets.nix
    ./credentials.nix
    ./programs/cli
    ./programs/desktop/vscodium.nix
  ];

}
