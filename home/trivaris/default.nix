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

  features = import ./features.nix { inherit config; };

}