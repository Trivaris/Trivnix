{ 
  config, 
  ... 
}: { 
  
  imports = [
    ../common
    ../features/cli
    ./home.nix
    ./credentials.nix
  ];

}