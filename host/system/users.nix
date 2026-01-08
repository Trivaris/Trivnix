{
  config,
  allUserInfos,
  allUserPrefs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mapAttrsToList
    nameValuePair
    ;

  allShells = mapAttrsToList (_: prefs: prefs.shell) allUserPrefs;

  sshKeys = map builtins.readFile (lib.collect builtins.isPath config.private.pubKeys.hosts);

  allUsers = {
    root = {
      hashedPassword = config.hostInfos.hashedRootPassword;
      openssh.authorizedKeys.keys = sshKeys;
    };
  }
  // (mapAttrs (username: userInfos: {
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
  }) allUserInfos);
in
{
  programs = builtins.listToAttrs (map (shell: nameValuePair shell { enable = true; }) allShells);
  users = {
    mutableUsers = false;
    users = allUsers;
  };
}
