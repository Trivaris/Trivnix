{
  flake.homeModules.system-ssh =
    { lib, config, ... }:
    {
      options.home.preferences.sshHosts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
        default = { };
        description = ''
          SSH host blocks passed through to `programs.ssh.settings`.
          Attribute names are Host patterns; values use upstream
          OpenSSH directive names (see ssh_config(5)).
        '';
      };

      config.programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = lib.mkMerge [
          {
            "*" = {
              identitiesOnly = true;
              addKeysToAgent = "no";
              identityFile = [ config.sops.secrets.ssh-private-key.path];
            };
          }
          config.home.preferences.sshHosts
        ];
      };
    };
}
