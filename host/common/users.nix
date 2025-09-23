{
  lib,
  pkgs,
  inputs,
  allUserInfos,
  allUserPrefs,
  hostInfos,
  trivnixLib,
  ...
}:
let
  inherit (lib) mapAttrsToList mapAttrs' nameValuePair;
  sshKeys = trivnixLib.recursiveAttrValues (removeAttrs inputs.trivnixPrivate.pubKeys [ "common" ]);
  allShells = mapAttrsToList (_: prefs: prefs.shell) allUserPrefs;

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
      openssh.authorizedKeys.keys = sshKeys;
      useDefaultShell = true;
    }
  ) allUserInfos);
in
{
  programs = builtins.listToAttrs (map (shell: nameValuePair shell { enable = true; }) allShells);
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users = allUsers;
  };
}
