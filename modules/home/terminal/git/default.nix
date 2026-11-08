{
  flake.homeModules.terminal-git =
    {
      osConfig,
      config,
      lib,
      ...
    }:
    let
      gitPreferences = config.user.preferences.git;
      allowedSignersFile = ".config/git/allowed_signers";
    in
    {
      programs = {
        git = {
          enable = true;

          settings = {
            user = {
              inherit (gitPreferences) name email;
            };

            credential.helper = "store";
            init.defaultBranch = "main";
            gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${allowedSignersFile}";
            url = lib.mapAttrs (_: value: { insteadOf = value; }) gitPreferences.urlAliases;

            color.diff = {
              meta = "black bold";
              frag = "magenta";
              context = "white";
              whitespace = "yellow reverse";
              old = "red";
            };

            status = {
              branch = true;
              showStash = true;
              showUntrackedFiles = true;
            };

            core.autocrlf = "input";
          };

          signing = lib.mkIf gitPreferences.enableSigning {
            format = "ssh";
            signByDefault = true;
            key = "${config.sops.secrets.git-signing-key.path}";
          };
        };

        diff-so-fancy = {
          enable = true;
          enableGitIntegration = true;
          settings.markEmptyLines = false;
        };
      };

      home.file.${allowedSignersFile}.text = lib.mkIf gitPreferences.enableSigning ''
        ${gitPreferences.email} ${
          osConfig.host.private.publicKeys.common.${config.home.username}."id_git_signing.pub"
        }
      '';
    };
}
