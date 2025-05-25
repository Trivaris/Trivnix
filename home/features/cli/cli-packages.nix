{
  pkgs,
  ...
}: {

    home.packages = with pkgs; [
      coreutils
      httpie
      fd
      btop
      procs
      ripgrep
      tldr
      zip
  ];
  
}