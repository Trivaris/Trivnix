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
    getExe
    getExe'
    ;

  prefs = config.hostPrefs;
in
{
  options.hostPrefs.autoUpgrade = {
    enable = mkEnableOption ''
      Enable unattended upgrades driven by git pulls and nixos-rebuild.
      Turn this on for hosts that should track the configured flake branch.
    '';

    repoUrl = mkOption {
      type = types.str;
      default = "git@github.com:Trivaris/trivnix.git";
      description = ''
        Git remote cloned by the auto-upgrade service before rebuilding.
        Point this at the flake that exports the host configuration.
      '';
    };

    branch = mkOption {
      type = types.str;
      default = "main";
      description = ''
        Branch name fetched on each upgrade cycle.
        Changes landed on this branch trigger a nixos-rebuild switch.
      '';
    };

    workdir = mkOption {
      type = types.str;
      default = "/var/lib/trivnix";
      description = ''
        Directory where the flake is cloned and kept between runs.
        The service performs git operations and builds inside this path.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "1min";
      description = ''
        Systemd time string controlling how frequently upgrades run.
        Applies to both the initial delay and the recurring check interval.
      '';
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
            ${getExe pkgs.git} clone --depth=1 -b "$BRANCH" "$REPO_URL" "$WORKDIR"
          else
            echo "[trivnix] Fetching updates for $WORKDIR"
            ${getExe pkgs.git} -C "$WORKDIR" fetch --prune origin "$BRANCH"
          fi

          LOCAL="$(${getExe pkgs.git} -C "$WORKDIR" rev-parse HEAD || true)"
          REMOTE="$(${getExe pkgs.git} -C "$WORKDIR" rev-parse "origin/$BRANCH" || true)"

          if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
            echo "[trivnix] Updating to origin/$BRANCH"
            ${getExe pkgs.git} -C "$WORKDIR" reset --hard "origin/$BRANCH"
            echo "[trivnix] Rebuilding NixOS for $HOST"
            ${getExe' pkgs.nixos-rebuild "nixos-rebuild"} switch --flake "$WORKDIR#$HOST" --refresh
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
