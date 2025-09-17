{
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkOption types;
  prefs = config.userPrefs;
in
{
  options.userPrefs.git.email = mkOption {
    type = types.str;
    example = "you@example.com";
    description = ''
      Email address written to the global Git config as `user.email`.
      Match your forge account address so commits stay attributed correctly.
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
