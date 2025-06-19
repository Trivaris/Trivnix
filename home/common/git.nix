{
  username,
  config,
  pkgs,
  lib,
  ...
}:
let
  keyPath = config.sops.secrets."ssh-user-key/key".path;
  passPath = config.sops.secrets."ssh-user-key/passphrase".path;

  askPass = pkgs.writeShellScriptBin "ssh-askpass-${username}" ''
    exec cat ${passPath}
  '';
in
{

  options.userGitEmail = lib.mkOption {
    type = lib.types.str;
    description = "Git Email Address";
    example = "me@example.com";
  };

  config = {
    programs.git = {
      enable = true;
      userName = username;
      userEmail = config.userGitEmail;
      extraConfig.credential.helper = "store";
      extraConfig.core.autocrlf = "input";
    };

    programs.keychain = {
      enable = true;
      keys = [ keyPath ];
      extraFlags = [ "--quiet" ];
    };

    programs.ssh.extraConfig = ''
      IdentityFile ${keyPath}
    '';

    home.sessionVariables = {
      SSH_ASKPASS = "${askPass}/bin/ssh-askpass-${username}";
      SSH_ASKPASS_REQUIRE = "force";
      DISPLAY = ":0";
    };

    home.packages = [ askPass ];
  };

}
