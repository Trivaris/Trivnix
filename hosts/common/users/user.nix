{
  libExtra,
  config,
  username,
  stateVersion,
  lib,
  users,
  hosts,
  ...
}:
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

  home-manager.extraSpecialArgs = { inherit username stateVersion; };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets."user-passwords/${username}".path;
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = username;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
      "Docker"
    ];
    openssh.authorizedKeys.keys = allAuthorizedKeys;
  };

}
