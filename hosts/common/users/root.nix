{
  config,
  lib,
  libExtra,
  hosts,
  ...
}:
let
  inherit (lib) mapAttrsToList flatten;

  readKey = path: builtins.readFile (libExtra.mkFlakePath path);

  allAuthorizedKeys = flatten (
    mapAttrsToList (
      hostname: hostcfg:
      let
        hostKey = readKey "/resources/ssh-pub/id_ed25519_${hostname}_host.pub";
        userKeys = flatten (
          map (
            user:
            if hostcfg.hardwareKey or true then
              [
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_a.pub")
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_c.pub")
              ]
            else
              [
                (readKey "/resources/ssh-pub/id_ed25519_${hostname}_${user}.pub")
              ]
          ) hostcfg.users
        );
      in
      [ hostKey ] ++ userKeys
    ) hosts
  );
in
{

  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
    openssh.authorizedKeys.keys = allAuthorizedKeys;
  };

}
