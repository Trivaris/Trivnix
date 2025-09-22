{
  config,
  lib,
  inputs,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    ;

  prefs = config.userPrefs;
  allowedSignersFile = ".config/git/allowed_signers";
in
{
  options.userPrefs.git = {
    enableSigning = mkEnableOption ''
      Enables commit and tag signing in Git using a configured ssh key defined via sops-nix.
      Ensures authenticity of your commits, marking them as verified on platforms like GitHub/GitLab.
    '';

    name = mkOption {
      type = types.str;
      default = userInfos.name;
      example = "trivaris";
      description = ''
        Name written to the global Git config as `user.name`.
        Match your forge account name so commits stay attributed correctly.
      '';
    };

    email = mkOption {
      type = types.str;
      example = "you@example.com";
      description = ''
        Email address written to the global Git config as `user.email`.
        Match your forge account address so commits stay attributed correctly.
      '';
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = prefs.git.name;
      userEmail = prefs.git.email;

      signing = mkIf prefs.git.enableSigning {
        format = "ssh";
        signByDefault = true;
        key = "${config.sops.secrets.git-signing-key.path}";
      };

      extraConfig = {
        credential.helper = "store";
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${allowedSignersFile}";
        core = {
          autocrlf = "input";
          hooksPath = ".githooks";
        };
      };
    };

    home.file.${allowedSignersFile}.text = mkIf prefs.git.enableSigning ''
      ${prefs.git.email} ${inputs.trivnixPrivate.pubKeys.common.${userInfos.name}."id_git_signing.pub"}
    '';
  };
}
