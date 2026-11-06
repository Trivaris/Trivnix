{
  imports = [
    ./secrets.nix
  ];

  flake.nixosModules.system-users =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = false;
        defaultUserShell = pkgs.zsh;
      };
    };
}
