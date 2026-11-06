{
  mkOption,
  types,
  ...
}@lib:
let
  reverseProxyOptions = import ./_reverseProxyOptions.nix lib;
in
mkOption {
  description = "List of services with name, ports, and domain.";

  type = types.submodule reverseProxyOptions;
}
