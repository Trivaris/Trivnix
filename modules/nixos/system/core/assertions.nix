{
  flake.nixosModules.system-core =
    { config, ... }:
    {
      config.assertions = [
        {
          assertion = !config.host.preferences.headless || !config.programs.hyprland.enable;
          message = "host.preferences.headless cannot be enabled together with programs.hyprland.enable.";
        }
        {
          assertion =
            config.host.preferences.headless
            || (
              config.host.info.primaryMonitor != null
              && builtins.hasAttr config.host.info.primaryMonitor config.host.info.monitors
            );
          message = "host.info.primaryMonitor must identify an entry in host.info.monitors.";
        }
      ];
    };
}
