{
  mkOption,
  types,
  ...
}@lib:
let
  reverseProxyOptions = import ./reverseProxyOptions.nix lib;
in
mkOption {
  description = "List of services with name, ports, and domain.";

  type = types.submodule reverseProxyOptions;
}
