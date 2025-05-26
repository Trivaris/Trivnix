{ 
  config, 
  ... 
}: { 
  
  imports = [
    ../common
    ../features
    ./home.nix
    ./credentials.nix
    ./dotfiles
  ];

  features = import ./features.nix { inherit config; };

}