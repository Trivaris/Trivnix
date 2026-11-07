{
  flake.nixosModules.system-users =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
      users = {
        mutableUsers = false;
        defaultUserShell = pkgs.zsh;
      };
    };
}
