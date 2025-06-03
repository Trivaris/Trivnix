{
  inputs,
  pkgs,
  ...
}:
{

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = [
      "-l"
      "--icons"
      "--git"
      "-a"
    ];
  };

  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/nvim";
    recursive = true;
  };

}
