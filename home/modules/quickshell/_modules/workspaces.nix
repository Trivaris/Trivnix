{ pkgs, lib, osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
  monitors = osConfig.hostInfos.monitors;
  indecies = lib.mapAttrsToList (_: monitor: monitor.workspaceIndex) monitors;

  workspacesMap = builtins.listToAttrs (
    lib.flatten (
      map (
        digit:
        map (monitorIndex: {
          name = toString (digit + (monitorIndex * 10));
          value = "<span color='${theme.base03}'></span>";
        }) indecies
      ) (lib.range 1 5)
    )
  ) // {
    "1" = "<span color='${theme.base08}'>󰈹</span>";
    "2" = "<span color='${theme.base0C}'>󰅩</span>";
    "3" = "<span color='${theme.base0B}'></span>";
    "11" = "<span color='${theme.base0E}'></span>";
    "12" = "<span color='${theme.base0D}'></span>";
  };
in
{
  settings = {
    "hyprland/workspaces" = {
      "all-outputs" = false;
      "active-only" = false;
      "format" = "{icon}";
      "persistent-workspaces" = lib.mapAttrs (_: mon: map (i: toString (i + (mon.workspaceIndex * 10))) (lib.range 1 5)) osConfig.hostInfos.monitors;
      "format-icons" = workspacesMap;
      "on-click" = "${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({{ workspace = {name} }})'";
    };
  };

  style = ''
    #workspaces button {
      transition: all 0.2s ease-in-out;
      padding: 0.4rem 0.8rem; 

      border: none;

      border-bottom: 0.2rem solid transparent;
      
      border-top-left-radius: 0.5rem;
      border-top-right-radius: 0.5rem;
      border-bottom-left-radius: 0.25rem;
      border-bottom-right-radius: 0.25rem;
    }

    #workspaces button.active {
      color: ${theme.base0D};
      background: transparent;
      border-bottom: 0.2rem solid ${theme.base0D};
    }

    #workspaces button:hover {
      background: rgba(255, 255, 255, 0.1);
      border-bottom: 0.2rem solid ${theme.base03};
      box-shadow: inherit;
      text-shadow: inherit;
    }

    #workspaces button.active:hover {
      background: rgba(255, 255, 255, 0.15);
      border-bottom: 0.2rem solid ${theme.base0D};
    }
  '';
}
