{
  flake.nixosModules.networking-wireguard = { lib, ... }: {
    options.host.vars.wireguard-address = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Own wireguard vpn address";
      readOnly = true;
    };
  };
}
