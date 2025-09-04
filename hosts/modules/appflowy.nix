{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.hostPrefs;
  dockerGroup = config.users.groups.docker.name or "docker";
in
{
  options.hostPrefs.appflowy.enable = mkEnableOption "Enable Appflowy";

  config = mkIf (prefs.appflowy.enable) {
    virtualisation.docker.enable = true;
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        docker
        docker-compose
        ;
    };

    systemd.services.appflowy-cloud = {
      description = "AppFlowy Cloud Stack";
      after = [ "docker.service" ];
      wants = [ "docker.service" ];

      # Bind the source from the flake input
      serviceConfig = {
        WorkingDirectory = prefs.appflowy.dir;
        ExecStart = "${pkgs.docker-compose}/bin/docker compose -f ${prefs.appflowy.dir}/docker-compose.yml up -d";
        ExecStop = "${pkgs.docker-compose}/bin/docker compose -f ${prefs.appflowy.dir}/docker-compose.yml down";
        Restart = "on-failure";
      };

      preStart = ''
        rm -rf ${prefs.appflowy.dir}
        mkdir -p ${prefs.appflowy.dir}
        cp -r --no-preserve=ownership ${inputs.appflowy}/. ${prefs.appflowy.dir}
        chown -R ${dockerGroup}:${dockerGroup} ${prefs.appflowy.dir}
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
