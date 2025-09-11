pkgs: {
  default = pkgs.mkShell {
    packages = builtins.attrValues {
      inherit (pkgs)
        git
        nixfmt
        statix
        deadnix
        shellcheck
        ;
    };
  };
}
