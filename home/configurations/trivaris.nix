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
      hyprland.enable = true;
      librewolf.enable = false;
      wezterm.enable = true;
      cli-utils.enable = true;
      fish.enable = true;
      font.enable = true;
      fzf.enable = true;
      nvim.enable = true;
      rofi.enable = true;
      waybar.enable = true;
    };

    inherit userGitEmail;
  };

  wsl = { libExtra, ... }: {

    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = {
      cli-utils.enable = true;
      fish.enable = true;
    };

    inherit userGitEmail;
  };

  server = { libExtra, ... }: {
    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = {
      cli-utils.enable = true;
      fish.enable = true;
    };

    inherit userGitEmail;
  };

  desktop = { libExtra, ... }: {

    imports = [
      (libExtra.mkFlakePath /home/common)
      (libExtra.mkFlakePath /home/modules)
    ];

    homeModules = {
      hyprland.enable = true;
      librewolf.enable = false;
      wezterm.enable = true;
      cli-utils.enable = true;
      fish.enable = true;
      font.enable = true;
      fzf.enable = true;
      nvim.enable = true;
      rofi.enable = true;
      waybar.enable = true;
    };

    inherit userGitEmail;
  };
    
}
