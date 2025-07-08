let
  userGitEmail = "github@tripple.lurdane.de";
in
{

  laptop = { lib-extra, ... }: {

    imports = [
      (lib-extra.mkFlakePath /home/common)
      (lib-extra.mkFlakePath /home/modules)
    ];

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

  wsl = { lib-extra, ... }: {

    imports = [
      (lib-extra.mkFlakePath /home/common)
      (lib-extra.mkFlakePath /home/modules)
    ];

    homeModules = {
      cli-utils = true;
      fish = true;
      vscodium = true;
    };

    inherit userGitEmail;
  };
    
}
