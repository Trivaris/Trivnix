let
  userGitEmail = "github@tripple.lurdane.de";
in
{

  laptop = { lib-extra, ... }: lib-extra.mkHomeConfig {
    homeModules = {
      hyprland = true;
      librewolf = false;
      wezterm = true;
      cli-utils = true;
      fish = true;
      font = true;
      fzf = true;
      nvim = true;
      rofi = true;
      vscodium = true;
      waybar = true;
    };

    inherit userGitEmail;
  };

  wsl = { lib-extra, ... }: lib-extra.mkHomeConfig {
    homeModules = {
      cli-utils = true;
      fish = true;
      vscodium = true;
    };

    inherit userGitEmail;
  };
    
}
