{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
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
}
