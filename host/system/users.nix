{
  allUserInfos,
  allUserPrefs,
  hostInfos,
  inputs,
  lib,
  pkgs,
  trivnixLib,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    pipe
    ;

  allShells = mapAttrsToList (_: prefs: prefs.shell) allUserPrefs;

  sshKeys =
    pipe
      [ "common" hostInfos.configname ]
      [
        (removeAttrs inputs.trivnixPrivate.pubKeys)
        (mapAttrs (_: value: (removeAttrs value.users [ "root" ])))
        trivnixLib.recursiveAttrValues
      ];

  allUsers = {
    root = {
      hashedPassword = hostInfos.hashedRootPassword;
      openssh.authorizedKeys.keys = sshKeys;
    };
  }
  // (mapAttrs' (
    username: userInfos:
    nameValuePair username {
      inherit (userInfos) hashedPassword;
      isNormalUser = true;
      createHome = true;
      home = "/home/${username}";
      description = username;
      openssh.authorizedKeys.keys = sshKeys;
      useDefaultShell = true;
      shell = pkgs.${allUserPrefs.${username}.shell};
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
    }
  ) allUserInfos);
in
{
  programs = builtins.listToAttrs (map (shell: nameValuePair shell { enable = true; }) allShells);
  users = {
    mutableUsers = false;
    users = allUsers;
  };
}
