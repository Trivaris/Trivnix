{ config, lib, pkgs, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.greetd = import ./config.nix { inherit pkgs lib; };

  config = mkIf cfg.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.${cfg.greetd.pkg}}/bin/${cfg.greetd.pkg} --time --cmd '${cfg.greetd.command}'";
          user = cfg.greetd.user;
        };
      };
    };

    users.users.${cfg.greetd.user} = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/${cfg.greetd.user}";
      shell = pkgs.bashInteractive;
      group = cfg.greetd.user;
    };

    users.groups.${cfg.greetd.user} = { };
  };
}
