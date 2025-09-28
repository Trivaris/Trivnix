{ pkgs }:
{
  default = pkgs.mkShell {
    packages = builtins.attrValues {
      inherit (pkgs)
        deadnix
        git
        nixfmt
        shellcheck
        statix
        ;
    };
  };
}
