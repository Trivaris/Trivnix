{
  username,
  config,
  lib,
  ...
}:
{

  options.userGitEmail = lib.mkOption {
    type = lib.types.str;
    description = "Git Email Address";
  };

  config = {
    programs.git = {
      enable = true;
      userName = username;
      userEmail = config.userGitEmail;
      extraConfig.credential.helper = "store";
      extraConfig.core.autocrlf = "input";
    };

  };

}
