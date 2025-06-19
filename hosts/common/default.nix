{ ... }:
{

  imports = [
    ./users
    ./auto-upgrade.nix
    ./cli-utils.nix
    ./home-manager.nix
    ./keymap.nix
    ./nixos.nix
    ./secrets.nix
    ./ssh.nix
    ./timezone.nix
  ];

}
