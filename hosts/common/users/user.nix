{
  inputs,
  outputs,
  config,
  lib,
  libExtra,
  
  userconfig,
  username,
  hostconfig,
  configname,
  hosts,

  ...
}:
let
  inherit (lib) mapAttrsToList flatten;

  readKey = path: builtins.readFile (libExtra.mkFlakePath path);

  allAuthorizedKeys = flatten (
    mapAttrsToList ( hostname: hostcfg:
      let
        hostKey = readKey "/resources/ssh-pub/id_ed25519_${hostname}_host.pub";
        userKeys = flatten (
          map ( user:
            if hostcfg.hardwareKey or true then
              [
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_a.pub")
                (readKey "/resources/ssh-pub/id_ed25519_sk_rk_${hostname}_${user}_c.pub")
              ]
            else
              [
                (readKey "/resources/ssh-pub/id_ed25519_${hostname}_${user}.pub")
              ]
          ) hostcfg.users or []
        );
      in
      [ hostKey ] ++ userKeys
    ) hosts
  );
in
{

  home-manager.extraSpecialArgs = {
    inherit
      hostconfig
      configname
      hosts;
    inherit
      inputs
      outputs
      libExtra;
    userconfig = userconfig // { name = username; };
  };

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
      "docker"
    ];
    openssh.authorizedKeys.keys = allAuthorizedKeys;
    useDefaultShell = true;
  };

}
