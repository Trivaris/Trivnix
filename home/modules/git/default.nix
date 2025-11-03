{
  config,
  inputs,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mapAttrs' mkIf nameValuePair;
  prefs = config.userPrefs;
  allowedSignersFile = ".config/git/allowed_signers";
in
{
  programs.git = {
    enable = true;
    userName = prefs.git.name;
    userEmail = prefs.git.email;

    signing = mkIf prefs.git.enableSigning {
      format = "ssh";
      signByDefault = true;
      key = "${config.sops.secrets.git-signing-key.path}";
    };

    diff-so-fancy = {
      enable = true;
      markEmptyLines = false;
    };

    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${allowedSignersFile}";
      url = mapAttrs' (name: value: nameValuePair name { insteadOf = value; }) prefs.git.urlAliases;

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
  };

  home.file.${allowedSignersFile}.text = mkIf prefs.git.enableSigning ''
    ${prefs.git.email} ${inputs.trivnixPrivate.pubKeys.common.${userInfos.name}."id_git_signing.pub"}
  '';
}
