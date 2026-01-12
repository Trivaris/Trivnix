{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  allowedSignersFile = ".config/git/allowed_signers";
in
{
  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          inherit (prefs.git) name email;
        };

        credential.helper = "store";
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${allowedSignersFile}";
        url = lib.mapAttrs (_: value: { insteadOf = value; }) prefs.git.urlAliases;

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

        core = {
          autocrlf = "input";
          hooksPath = ".githooks";
        };
      };

      signing = lib.mkIf prefs.git.enableSigning {
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

  home.file.${allowedSignersFile}.text = lib.mkIf prefs.git.enableSigning ''
    ${prefs.git.email} ${config.private.pubKeys.common.${config.userInfos.name}."id_git_signing.pub"}
  '';
}
