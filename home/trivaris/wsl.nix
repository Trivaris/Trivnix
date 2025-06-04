{ ... }:
{

  imports = [
    ../../modules/home/common/theme.nix
    ../../modules/home/trivaris/base.nix
    ../../modules/home/trivaris/secrets.nix
    ../../modules/home/trivaris/credentials.nix
    ../../modules/home/common/programs/cli
    ../../modules/home/common/programs/desktop/vscodium.nix
  ];

}
