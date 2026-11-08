{
  flake.homeModules.apps-thunderbird =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      thunderbirdPreferences = config.user.preferences.thunderbird;

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
      #   ) config.private.calendarAccounts or { }
      # );
    in
    {
      options.user.preferences.thunderbird.enable = lib.mkEnableOption "Thunderbird configuration";
      config = lib.mkIf thunderbirdPreferences.enable {
        programs.thunderbird = {
          enable = true;
          package = pkgs.thunderbird-bin;
          profiles.${config.home.username} = {
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
