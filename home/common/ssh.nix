{
  config,
  lib,
  userconfig,
  hostconfig,
  hosts,
  ...
}:
let 
  aliases = builtins.listToAttrs (
    lib.concatMap (configname:
      let
        host = hosts.${configname};
      in
      [{
        name = host.name;
        value = {
          hostname = host.ip;
          user = userconfig.name;
        } // (if host.nixosModules.openssh ? port then { port = builtins.head host.nixosModules.openssh.ports; } else {});
      }]
    ) (lib.attrNames (lib.filterAttrs (_: host: host.nixosModules.openssh.enable or false) hosts))
  );
in 
{

  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile = if hostconfig.hardwareKey then [
          config.sops.secrets.ssh-private-key-a.path
          config.sops.secrets.ssh-private-key-c.path
        ] else [
          config.sops.secrets.ssh-private-key.path
        ];
      };
    } // aliases;
  };

}
