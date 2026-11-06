{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = [
    pkgs.deadnix
    pkgs.git
    pkgs.nixfmt
    pkgs.shellcheck
    pkgs.statix
    pkgs.nixd
  ];
}
