{ ... }:
{

  imports = [
    ./home-manager.nix
    ./secrets.nix
    ./users
    ./keymap.nix
    ./nix-config.nix
    ./system-packages.nix
    ./auto-upgrade.nix
  ];

}
