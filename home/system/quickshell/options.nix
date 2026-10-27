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
        regex = lib.mkOption {
          type = lib.types.str;
          description = "Regular expression matched against an application identifier";
        };
        text = lib.mkOption {
          type = lib.types.str;
          description = "Icon text displayed for matching applications";
        };
        color = lib.mkOption {
          type = lib.types.str;
          description = "Color applied to the displayed icon";
        };
      };
    });
    description = ''
      Rules that override the icon, text, and color used for matching application identifiers.
    '';
  };
}