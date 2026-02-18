{ lib, osConfig, ... }:
let
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

  style = "";
}
