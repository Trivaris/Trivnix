{
  flake.nixosModules.system-core =
    { lib, config, ... }:
    let
      mkStrOptionWithDefault =
        desc: def:
        lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = def;
          description = desc;
        };
      mkStrOption =
        desc:
        lib.mkOption {
          type = lib.types.nonEmptyStr;
          description = desc;
        };
    in
    {
      options.host.info = {
        name = mkStrOption "Name assigned to the host.";
        configName = mkStrOption "Name of the host configuration.";
        wireguardName = mkStrOptionWithDefault "Name of the WireGuard peer for this host." config.host.info.configName;
        loginUser = mkStrOption "User to log in automatically.";
        stateVersion = mkStrOption "NixOS state version used by this host.";
        architecture = mkStrOption "System architecture of this host.";
        primaryMonitor = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          default = null;
          description = "Identifier of the primary monitor, if this host has a graphical display.";
        };
        monitors = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                resolution = mkStrOption "Resolution of the monitor.";
                refreshRate = mkStrOption "Refresh rate of the monitor.";
                position = mkStrOption "Position of the monitor in the layout.";
                scaling = mkStrOption "Scaling factor for the monitor.";
                workspaceIndex = lib.mkOption {
                  type = lib.types.int;
                  default = 0;
                  description = "0 for workspaces 1-10, 1 for workspaces 11-20, etc.";
                };
              };
            }
          );
        };
      };
    };
}
