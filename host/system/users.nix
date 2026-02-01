{
  config,
  lib,
  pkgs,
  ...
}:
let
  sshKeys = map builtins.readFile (lib.collect builtins.isPath config.private.pubKeys.hosts);
  allUserInfos = builtins.mapAttrs (_: cfg: cfg.userInfos) config.home-manager.users;

  allUsers = {
    root = {
      hashedPassword = config.hostInfos.hashedRootPassword;
      openssh.authorizedKeys.keys = sshKeys;
    };
  }
  // (lib.mapAttrs (username: userInfos: {
    inherit (userInfos) hashedPassword uid;
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = username;
    openssh.authorizedKeys.keys = sshKeys;
    useDefaultShell = true;
    shell = pkgs.zsh;
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
  programs.zsh.enable = true;
  users = {
    mutableUsers = false;
    users = allUsers;
  };
}
