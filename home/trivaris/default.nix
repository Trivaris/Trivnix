{ 
  config, 
  ... 
}: { 
  
  imports = [
    ../common/themes/material-green.nix
    ./home.nix
    ./credentials.nix
    ./programs
  ];

}