{
  config,
  lib,
  pkgs,
  hostInfos,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.autoUpgrade = {
    enable = mkEnableOption "Automatically pull and rebuild when upstream changes";

    repoUrl = mkOption {
      type = types.str;
      default = "git@github.com:Trivaris/trivnix.git";
      description = "Git URL of the flake repository to track";
    };

    branch = mkOption {
      type = types.str;
      default = "main";
      description = "Branch to track for upgrades";
    };

    workdir = mkOption {
      type = types.str;
      default = "/var/lib/trivnix";
      description = "Local clone path used for building the flake";
    };

    interval = mkOption {
      type = types.str;
      default = "1min";
      description = "How often to check for upstream changes (systemd time span)";
    };
  };

  config = mkIf prefs.autoUpgrade.enable {
    systemd.services.trivnix-auto-upgrade =
      let
        upgradeScript = ''
          set -euo pipefail

          REPO_URL="${prefs.autoUpgrade.repoUrl}"
          BRANCH="${prefs.autoUpgrade.branch}"
          WORKDIR="${prefs.autoUpgrade.workdir}"
          HOST="${hostInfos.configname}"

          mkdir -p "${prefs.autoUpgrade.workdir}"

          if [ ! -d "$WORKDIR/.git" ]; then
            echo "[trivnix] Cloning $REPO_URL ($BRANCH) into $WORKDIR"
            ${lib.getExe pkgs.git} clone --depth=1 -b "$BRANCH" "$REPO_URL" "$WORKDIR"
          else
            echo "[trivnix] Fetching updates for $WORKDIR"
            ${lib.getExe pkgs.git} -C "$WORKDIR" fetch --prune origin "$BRANCH"
          fi

          LOCAL="$(${lib.getExe pkgs.git} -C "$WORKDIR" rev-parse HEAD || true)"
          REMOTE="$(${lib.getExe pkgs.git} -C "$WORKDIR" rev-parse "origin/$BRANCH" || true)"

          if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
            echo "[trivnix] Updating to origin/$BRANCH"
            ${lib.getExe pkgs.git} -C "$WORKDIR" reset --hard "origin/$BRANCH"
            echo "[trivnix] Rebuilding NixOS for $HOST"
            ${lib.getExe' pkgs.nixos-rebuild "nixos-rebuild"} switch --flake "$WORKDIR#$HOST" --refresh
          else
            echo "[trivnix] No changes; skipping rebuild"
          fi
        '';
      in
      {
        description = "Trivnix auto-upgrade: pull repo and rebuild when upstream changes";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        script = upgradeScript;

        serviceConfig = {
          Type = "oneshot";
          WorkingDirectory = prefs.autoUpgrade.workdir;
        };

        path = builtins.attrValues {
          inherit (pkgs)
            git
            nixos-rebuild
            nix
            coreutils
            bash
            openssh
            ;
        };
      };

    systemd.timers.trivnix-auto-upgrade = {
      description = "Timer for trivnix auto-upgrade";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = prefs.autoUpgrade.interval;
        OnUnitInactiveSec = prefs.autoUpgrade.interval;
        Persistent = true;
      };
    };
  };
}
