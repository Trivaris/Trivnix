{
  inputs,
  ...
}:
{

  imports = [
    (inputs.self + "/modules")  
    ./colors
    ./default-programs.nix
    ./home.nix
    ./secrets.nix
  ];

  config = { };

}
