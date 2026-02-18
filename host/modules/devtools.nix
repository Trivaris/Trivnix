{
  lib,
  pkgs,
  config,
  ...
}:
let
  prefs = config.hostPrefs;
  users = map (user: {
    name = user;
    ensureClauses.superuser = true;
  }) (builtins.attrNames config.home-manager.users);
in
{
  options.hostPrefs.enableDevStuffs = lib.mkEnableOption "Enable Dev Stuffs lol";
  config = lib.mkIf prefs.enableDevStuffs {
    environment.systemPackages = [
      pkgs.gradle_9
      pkgs.kotlin-native
      pkgs.nixd
      pkgs.libGL
    ];

    programs.java = {
      enable = true;
      package = pkgs.openjdk21;
    };

    services.postgresql = {
      enable = true;
      ensureUsers = users;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-address  auth-method
        local all       all                   trust
        host  all       all     127.0.0.1/32  trust
        host  all       all     ::1/128       trust
      '';
    };
  };
}
