{
  userconfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption;
  cfg = config.homeConfig;
in
{
  options.homeConfig.git.email = mkOption {
    type = lib.types.str;
    example = "you@example.com";
    description = ''
      Email address to associate with Git commits.
      This will be used in the global Git configuration under `user.email`.
      It should match the email used in your Git hosting provider (e.g., GitHub, GitLab)
      to ensure commits are properly attributed.
    '';
  };

  config = {
    programs.git = {
      enable = true;
      userName = userconfig.name;
      userEmail = cfg.git.email;
      extraConfig.credential.helper = "store";
      extraConfig.core.autocrlf = "input";
    };

  };

}
