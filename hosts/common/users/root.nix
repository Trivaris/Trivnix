{ libExtra, config, hosts, users, lib, ... }:
let
  inherit (lib) mapAttrsToList concatMap flatten optionals;

  readKey = path: builtins.readFile (libExtra.mkFlakePath path);

  allAuthorizedKeys =
    flatten (
      mapAttrsToList
        (hostName: hostCfg:
          let
            hostKey = readKey "/resources/ssh-pub/id_ed25519_${hostName}_host.pub";
            userKeys = flatten (
              map (user:
                if hostCfg.hardwareKey or true then
                  [
                    (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostName}_${user}_a.pub")
                    (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostName}_${user}_c.pub")
                  ]
                else
                  [
                    (readKey "/resources/ssh-pub/id_ed25519_${hostName}_${user}.pub")
                  ]
              ) users
            );
          in
            [ hostKey ] ++ userKeys
        )
        hosts
    );
in
{

  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
    openssh.authorizedKeys.keys = allAuthorizedKeys;
  };

}
