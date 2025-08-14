{
  outputs,
  pkgs,
  lib,
  libExtra,
  userPrefs,
  hostInfo,
  ...
}:
{
  home.username = lib.mkDefault userPrefs.name;
  home.homeDirectory = lib.mkDefault "/home/${userPrefs.name}";
  home.stateVersion = hostInfo.stateVersion;

  systemd.user.services.rmClobbering = {
    Unit = {
      Description = "Remove unwanted backup files";
      After = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rm-clobbering" ''
        #!/usr/bin/env bash
        rm -f ~/.gtkrc-2.0.backup
        rm -f ~/.librewolf/${userPrefs.name}/search.json.mozlz4.backup
        rm -f ~/.config/gtk-3.0/gtk.css.backup 2>/dev/null || true
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.activation.runRmClobberingService =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      systemctl --user start rmClobbering.service || true
    '';

  nixpkgs = {
    overlays = builtins.attrValues (outputs.overlays);
    config = libExtra.pkgsConfig;
  };
}
