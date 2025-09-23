{ pkgs, ... }:
{
  environment.defaultPackages = builtins.attrValues {
    inherit (pkgs)
      coreutils
      wget
      zip
      jq
      fd
      fzf
      tldr
      procs
      git
      httpie
      openssh
      openssl
      file
      ;
  };

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
