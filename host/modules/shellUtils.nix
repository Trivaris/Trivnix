{ pkgs, ... }:
{
  environment.defaultPackages = builtins.attrValues {
    inherit (pkgs)
      coreutils
      fd
      file
      fzf
      git
      httpie
      jq
      openssh
      openssl
      procs
      tldr
      wget
      zip
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
