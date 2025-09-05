{
  pkgs,
  lib,
  hostInfos,
  userInfos,
  config,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  stylix.enable = true;

  home = {
    inherit (hostInfos) stateVersion;
    username = lib.mkDefault userInfos.name;
    homeDirectory = lib.mkDefault "/home/${userInfos.name}";

    sessionVariables = {
      TERMINAL = toString prefs.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };

    activation.runRmClobberingService = lib.hm.dag.entryAfter [
      "writeBoundary"
    ] "/run/current-system/sw/bin/systemctl --user start rmClobbering.service || true";
  };

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
        rm -f ~/.librewolf/${userInfos.name}/search.json.mozlz4.backup
        rm -f ~/.config/gtk-3.0/gtk.css.backup 2>/dev/null || true
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
