{ hostInfos, lib, ... }:
let
  inherit (lib)
    mkOption
    nameValuePair
    optionalString
    pipe
    replaceStrings
    splitString
    types
    ;

  parseMonitor =
    monitor:
    let
      parts = splitString "," monitor;
      body = pipe (if builtins.length parts > 2 then builtins.elemAt parts 2 else "0x0") [
        (splitString "x")
        builtins.head
        (replaceStrings [ "+" ] [ "" ])
        builtins.fromJSON
      ];
    in
    nameValuePair (builtins.head parts) body;

  monitorStrings = hostInfos.monitor or [ ];
  sortedMonitors = builtins.sort (a: b: a.value < b.value) (map parseMonitor monitorStrings);
  monitorCount = builtins.length sortedMonitors;
  middleIndex = if monitorCount == 0 then 0 else builtins.div (monitorCount - 1) 2;
in
{
  options.vars.mainMonitorName = mkOption {
    type = types.str;
    default = optionalString (monitorCount != 0) (builtins.elemAt sortedMonitors middleIndex).name;
  };
}
