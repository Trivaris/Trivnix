{
  flake.nixosModules.system-core =
    {
      config,
      lib,
      options,
      ...
    }:
    let
      hostInfo = config.host.info;
      hostPreferences = config.host.preferences;
      themingOptions = options.host.theming;
      hostTheming = config.host.theming;

      requiredSchemeKeys = map (digit: "base0${digit}") (lib.stringToCharacters "0123456789ABCDEF");
      missingSchemeKeys = lib.subtractLists (builtins.attrNames hostTheming.scheme) requiredSchemeKeys;
      isSetExplicitly = option: option.highestPrio < (lib.mkOptionDefault null).priority;
    in
    {
      config.assertions = [
        {
          assertion = !hostPreferences.headless || !config.programs.hyprland.enable;
          message = "host.preferences.headless cannot be enabled together with programs.hyprland.enable.";
        }
        {
          assertion =
            hostPreferences.headless
            || (hostInfo.primaryMonitor != null && builtins.hasAttr hostInfo.primaryMonitor hostInfo.monitors);
          message = "host.info.primaryMonitor must identify an entry in host.info.monitors.";
        }
        {
          assertion = missingSchemeKeys == [ ];
          message = "host.theming.scheme is missing base16 colors: ${lib.concatStringsSep ", " missingSchemeKeys}.";
        }
        {
          assertion =
            hostPreferences.headless || (config.users.users.${hostInfo.loginUser}.isNormalUser or false);
          message = "host.info.loginUser (${hostInfo.loginUser}) must be a normal user defined in users.users.";
        }
        {
          assertion = !(isSetExplicitly themingOptions.schemeName && isSetExplicitly themingOptions.scheme);
          message = ''
            host.theming.schemeName and host.theming.scheme are both set.
            Set schemeName to derive the palette, or scheme to provide a custom one, not both.
          '';
        }
      ];
    };
}
