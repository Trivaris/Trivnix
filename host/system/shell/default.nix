{ pkgs, ... }:
{
  environment.defaultPackages = [
    pkgs.coreutils
    pkgs.fd
    pkgs.file
    pkgs.fzf
    pkgs.git
    pkgs.httpie
    pkgs.jq
    pkgs.openssh
    pkgs.openssl
    pkgs.procs
    pkgs.tldr
    pkgs.wget
    pkgs.zip
  ];
}
