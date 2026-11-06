{
  flake.homeModules.apps-thunderbird =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      thunderbird-prefs = config.user-prefs.thunderbird;

      # calendarSettings = lib.flatten (
      #   lib.mapAttrsToList (
      #     name: account:
      #     let
      #       prefix = "calendar.registry.${account.uuid}";
      #     in
      #     [
      #       (lib.nameValuePair "${prefix}.uri" account.uri)
      #       (lib.nameValuePair "${prefix}.username" account.username)
      #       (lib.nameValuePair "${prefix}.name" name)
      #       (lib.nameValuePair "${prefix}.color" account.color)
      #       (lib.nameValuePair "${prefix}.disabled" false)
      #     ]
      #   ) config.private.calendar-accounts or { }
      # );
    in
    {
      options.user-prefs.thunderbird.enable = lib.mkEnableOption "Thunderbird configuration";
      config = lib.mkIf thunderbird-prefs.enable {
        programs.thunderbird = {
          enable = true;
          package = pkgs.thunderbird-bin;
          profiles.${config.user-infos.name} = {
            isDefault = true;
            # settings = (builtins.listToAttrs calendarSettings) // {
            #   "calendar.registry.defaultprovider" = "caldav";
            #   "signon.rememberSignons" = true;
            # };
          };
        };
      };
    };
}
