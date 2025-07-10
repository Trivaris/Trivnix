let
  userGitEmail = "github@tripple.lurdane.de";
in
{

  laptop = { libExtra, ... }: {

    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
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

  wsl = { libExtra, ... }: {

    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = {
      cli-utils = true;
      fish = true;
      vscodium = true;
    };

    inherit userGitEmail;
  };

  server = { libExtra, ... }: {
    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = {
      cli-utils = true;
      fish = true;
      vscodium = true;
    };

    inherit userGitEmail;
  };
    
}
