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

  features = {
    cli = {
      fish.enable = true;
    };
  };

}