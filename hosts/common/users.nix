{
  pkgs,
  lib,
  trivnixLib,
  hostInfos,
  allUserInfos,
  allUserPrefs,
  allHostPubKeys,
  ...
}:
let
  sshKeys = trivnixLib.recursiveAttrValues allHostPubKeys;

  allShells = lib.mapAttrsToList (_: prefs: prefs.shell) allUserPrefs;

  allUsers =
    (lib.mapAttrs' (
      username: userInfos:
      lib.nameValuePair username {
        hashedPassword = userInfos.hashedPassword;
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
    ) allUserInfos)
    // {
      root = {
        hashedPassword = hostInfos.hashedRootPassword;
        openssh.authorizedKeys.keys = sshKeys;
      };
    };
in
{
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users = allUsers;

  programs = builtins.listToAttrs (map (shell: lib.nameValuePair shell { enable = true; }) allShells);
}
