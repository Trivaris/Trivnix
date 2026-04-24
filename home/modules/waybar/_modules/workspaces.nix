{ lib, osConfig, ... }:
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
          value = toString digit;
        }) indecies
      ) (lib.range 1 10)
    )
  );
in
{
  settings = {
    "hyprland/workspaces" = {
      "all-outputs" = false;
      "active-only" = false;

      "format" = "{icon}";

      "format-icons" = workspacesMap;

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
