{
  flake.nixosModules.system-core =
    { lib, ... }:
    let
      mkStrOption =
        desc:
        lib.mkOption {
          type = lib.types.str;
          default = "";
          description = desc;
        };
    in
    {
      options.host-infos = {
        name = mkStrOption "The name of the host.";
        configname = mkStrOption "The configuration name of the host.";
        stateVersion = mkStrOption "The NixOS state version for this host.";
        architecture = mkStrOption "The system architecture of this host.";
        primaryMonitor = mkStrOption "The primary monitor identifier for this host.";
        monitors = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                resolution = mkStrOption "The resolution of the monitor.";
                refreshRate = mkStrOption "The refresh rate of the monitor.";
                position = mkStrOption "The position of the monitor in the layout.";
                scaling = mkStrOption "The scaling factor for the monitor.";
                workspaceIndex = lib.mkOption {
                  type = lib.types.int;
                  default = 0;
                  description = "0 for workspaces 1-10, 1 for workspaces 11-20, etc.";
                };
                wallpaper = lib.mkOption {
                  type = lib.types.path;
                  description = "The wallpaper path for the monitor.";
                };
              };
            }
          );
        };
      };
    };
}
