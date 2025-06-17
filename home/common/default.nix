{
  inputs,
  ...
}:
{

  imports = [
    ./colors
    ./default-programs.nix
    ./git.nix
    ./home.nix
    ./secrets.nix
    ./ssh.nix
  ];

  config = { };

}
