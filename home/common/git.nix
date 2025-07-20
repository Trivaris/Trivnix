{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{
  options.homeModules.git.email = mkOption {
    type = lib.types.str;
    description = "Git Email Address";
  };

  config = {
    programs.git = {
      enable = true;
      userName = username;
      userEmail = config.homeModules.git.email;
      extraConfig.credential.helper = "store";
      extraConfig.core.autocrlf = "input";
    };

  };

}
