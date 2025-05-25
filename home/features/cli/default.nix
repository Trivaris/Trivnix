{
  pkgs,
  ...
}: {

  imports = [
    ./fish.nix
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = [ "-l" "--icons" "--git" "-a" ];
  };

  programs.bat = {
    enable = true;
  };

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