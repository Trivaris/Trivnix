{
  lib,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
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

    urlAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        "git@github.com:example/" = "example:";
      };
    };
  };
}
