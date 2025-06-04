{ ... }:
{

  imports = [
    ../../modules/nixos/common/home-manager.nix
    ../../modules/nixos/common/secrets.nix
    ../../modules/nixos/users
    ../../modules/nixos/common/keymap.nix
    ../../modules/nixos/common/nix-config.nix
    ../../modules/nixos/common/packages.nix
    ../../modules/nixos/common/auto-upgrade.nix
  ];

}
