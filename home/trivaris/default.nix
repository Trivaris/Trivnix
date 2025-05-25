{ 
  config, 
  ... 
}: { 
  
  imports = [
    ../common
    ../features
    ./home.nix
    ./credentials.nix
  ];

  features = import ./features.nix { inherit config; };

}