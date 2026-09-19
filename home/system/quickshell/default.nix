{ osConfig, config, pkgs, lib, ... }:
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
        regex = { type = lib.types.str; };
        text = { type = lib.types.str; };
        color = { type = lib.types.str; };
      };
    });
  };

  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    systemd.user.services.quickshell.Service.Environment = "QSG_RHI_BACKEND=vulkan QML_XHR_ALLOW_FILE_READ=1";
    programs.quickshell = {
      enable = true;
      systemd.enable = true;
    };
    home = {
      packages = [ pkgs.quickshell ];
      file = {
        ".config/quickshell/wsIconOverrides.json".text = builtins.toJSON config.userPrefs.wsIconOverrides;
        ".config/quickshell/scheme.json".text = builtins.toJSON scheme;
        ".config/quickshell/monitors.json".text = builtins.toJSON osConfig.hostInfos.monitors;
        ".config/quickshell/weather.sh" = {
          executable = true;
          text = import ./_scripts/weather.nix pkgs;
        };
        ".config/quickshell" = {
          recursive = true;
          source = ./_modules;
        };
      };
    };
  };
}