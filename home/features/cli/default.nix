{
  pkgs,
  ...
}: {

  imports = [
    ./fish.nix
    ./fzf.nix
    ./cli-packages.nix
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

}