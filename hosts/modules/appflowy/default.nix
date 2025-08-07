{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig;
  dockerGroup = config.users.groups.docker.name or "docker";
in
{
  options.nixosConfig.appflowy.enable = mkEnableOption "Enable Appflowy";

  config = mkIf (cfg.appflowy.enable) {
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
        WorkingDirectory = cfg.appflowy.dir;
        ExecStart = "${pkgs.docker-compose}/bin/docker compose -f ${cfg.appflowy.dir}/docker-compose.yml up -d";
        ExecStop = "${pkgs.docker-compose}/bin/docker compose -f ${cfg.appflowy.dir}/docker-compose.yml down";
        Restart = "on-failure";
      };

      preStart = ''
        rm -rf ${cfg.appflowy.dir}
        mkdir -p ${cfg.appflowy.dir}
        cp -r --no-preserve=ownership ${inputs.appflowy}/. ${cfg.appflowy.dir}
        chown -R ${dockerGroup}:${dockerGroup} ${cfg.appflowy.dir}
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
