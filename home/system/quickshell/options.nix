{ osConfig, lib, ... }:
let 
  scheme = osConfig.themingPrefs.scheme;

  wsIconOverrides = [
    {
      regex = "/spotify|music|feishin/";
      text = "";
      color = scheme.base0E;
    }
    {
      regex = "/firefox|zen|chromium|librewolf/";
      text = "󰈹";
      color = scheme.base08;
    }
    {
      regex = "/discord|vesktop|webcord/";
      text = "";
      color = scheme.base0D;
    }
    {
      regex = "/steam/";
      text = "󰓓";
      color = scheme.base0A;
    }
    {
      regex = "/thunderbird/";
      text = "";
      color = scheme.base0D;
    }
    {
      regex = "/~|zsh|foot|kitty|alacritty|terminal/";
      text = "";
      color = scheme.base0B;
    }
    {
      regex = "/code/";
      text = "";
      color = scheme.base0C;
    }
  ];
in 
{
  options.userPrefs.quickshell.wsIconOverrides = lib.mkOption  {
    default = wsIconOverrides;
    type = lib.types.listOf (lib.types.submodule {
      options = {
        regex = lib.mkOption { type = lib.types.str; };
        text = lib.mkOption { type = lib.types.str; };
        color = lib.mkOption { type = lib.types.str; };
      };
    });
  };
}