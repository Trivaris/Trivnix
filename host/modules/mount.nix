{
  config,
  pkgs,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
  mainuser = config.users.users.${prefs.mainUser};
  mainuserGroup = config.users.groups.${mainuser.group};
in
{

  options.hostPrefs.mountSteamdeck = lib.mkEnableOption "Mount Steam Deck home directory via SSHFS";

  config = lib.mkIf prefs.mountSteamdeck {
    environment.systemPackages = [ pkgs.sshfs ];

    fileSystems."/mnt/steamdeck" = {
      device = "deck@steamdeck.fritz.box:/home/deck";
      fsType = "fuse.sshfs";
      options = [
        "x-systemd.automount"
        "noauto"

        "_netdev"
        "reconnect"
        "ServerAliveInterval=15"

        "IdentityFile=${
          if prefs.openssh.enable then
            config.sops.secrets.ssh-host-key.path
          else
            prefs.sops.secrets.ssh-root-key.path
        }"
        "allow_other"
        "umask=000"

        "uid=${toString mainuser.uid}"
        "gid=${toString mainuserGroup.gid}"
      ];
    };

    fileSystems."/mnt/steamdeck-sdcard" = {
      device = "deck@steamdeck.fritz.box:/run/media/deck/steamdeck";
      fsType = "fuse.sshfs";
      options = [
        "x-systemd.automount"
        "noauto"

        "_netdev"
        "reconnect"
        "ServerAliveInterval=15"

        "IdentityFile=${
          if prefs.openssh.enable then
            config.sops.secrets.ssh-host-key.path
          else
            prefs.sops.secrets.ssh-root-key.path
        }"
        "allow_other"
        "umask=000"

        "uid=${toString mainuser.uid}"
        "gid=${toString mainuserGroup.gid}"
      ];
    };
  };
}
