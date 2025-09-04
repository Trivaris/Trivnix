{
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkOption;
  prefs = config.userPrefs;
in
{
  options.userPrefs.git.email = mkOption {
    type = lib.types.str;
    example = "you@example.com";
    description = ''
      Email address to associate with Git commits.
      This will be used in the global Git config under `user.email`.
      It should match the email used in your Git hosting provider (e.g., GitHub, GitLab)
      to ensure commits are properly attributed.
    '';
  };

  config = {
    programs.git = {
      enable = true;
      userName = userInfos.name;
      userEmail = prefs.git.email;
      extraConfig = {
        credential.helper = "store";
        core.autocrlf = "input";
        init.defaultBranch = "main";
      };
    };
  };
}
