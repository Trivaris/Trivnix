{ inputs, ... }:
{

  imports = [
    ./credentials.nix
    
    (inputs.self + "/modules/base.nix")
    (inputs.self + "/modules/nvim.nix")
    (inputs.self + "/modules/secrets.nix")
  ];

}
