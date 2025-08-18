{
  config,
  pkgs,
  lib,
  trivnixLib,
  allUserInfos,
  allHostPubKeys,
  ...
}:
let
  sshKeys = trivnixLib.recursiveAttrValues allHostPubKeys;

  allUsers = (lib.mapAttrs' (username: userInfos:
    lib.nameValuePair
      username
      {
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
      hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
      openssh.authorizedKeys.keys = sshKeys;
    };
  };
in 
{
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users = allUsers;
}