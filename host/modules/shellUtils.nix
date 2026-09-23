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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      directory = {
        style = "blue";
      };
    };
  };
}
