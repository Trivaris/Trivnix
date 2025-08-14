{
  config,
  pkgs,
  lib,
  libExtra,
  allUserInfos,
  ...
}:
let
  sshKeyFiles = libExtra.resolveDir { dirPath = "/resources/ssh-pub"; mode = "paths"; includeNonNix = true; };

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
        openssh.authorizedKeys.keyFiles = sshKeyFiles;
        useDefaultShell = true;
      }
  ) allUserInfos)
  // {
    root = {
      hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
      openssh.authorizedKeys.keyFiles = sshKeyFiles;
    };
  };
in 
{
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users = allUsers;
}