{ libExtra, config, ... }:
let
  hosts = [
    "desktop"
    "laptop"
    "wsl"
    "server"
  ];
in
{

  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
    openssh.authorizedKeys.keys = map builtins.readFile (
      builtins.concatLists (
        map (host: [
          (libExtra.mkFlakePath "/resources/ssh-pub/id_ed25519_sk_${host}_a.pub")
          (libExtra.mkFlakePath "/resources/ssh-pub/id_ed25519_sk_${host}_c.pub")
        ]) hosts
      )
    );
  };

}
