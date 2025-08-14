{ config, userPrefs, allHostInfos, allHostUsers, lib, libExtra }:
let
  inherit (lib) mapAttrsToList flatten;

  readKey = path: builtins.readFile (libExtra.mkFlakePath path);

  allAuthorizedKeys = flatten (
    mapAttrsToList (
      hostname: hostInfo:
      let
        hostKey = readKey "/resources/ssh-pub/id_ed25519_${hostname}_host.pub";
        userKeys = flatten (
          map (
            user:
            if hostInfo.hardwareKey or true then
              [
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_a.pub")
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_c.pub")
              ]
            else
              [
                (readKey "/resources/ssh-pub/id_ed25519_${hostname}_${user}.pub")
              ]
          ) allHostUsers.${hostInfo.configname} or [ ]
        );
      in
      [ hostKey ] ++ userKeys
    ) allHostInfos
  );
in
{

  users.users.${userPrefs.name} = {
    hashedPasswordFile = config.sops.secrets."user-passwords/${userPrefs.name}".path;
    isNormalUser = true;
    createHome = true;
    home = "/home/${userPrefs.name}";
    description = userPrefs.name;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "input"
      "audio"
      "video"
      "render"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
      "docker"
    ];
    openssh.authorizedKeys.keys = allAuthorizedKeys;
    useDefaultShell = true;
  };

}
