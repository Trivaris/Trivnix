{
  flake.homeModules.terminal-git =
    {
      osConfig,
      config,
      lib,
      ...
    }:
    let
      git-prefs = config.user-prefs.git;
      allowedSignersFile = ".config/git/allowed_signers";
    in
    {
      programs = {
        git = {
          enable = true;

          settings = {
            user = {
              inherit (git-prefs) name email;
            };

            credential.helper = "store";
            init.defaultBranch = "main";
            gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${allowedSignersFile}";
            url = lib.mapAttrs (_: value: { insteadOf = value; }) git-prefs.urlAliases;

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

          signing = lib.mkIf git-prefs.enableSigning {
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

      home.file.${allowedSignersFile}.text = lib.mkIf git-prefs.enableSigning ''
        ${git-prefs.email} ${
          osConfig.private.public-keys.common.${config.home.username}."id_git_signing.pub"
        }
      '';
    };
}
