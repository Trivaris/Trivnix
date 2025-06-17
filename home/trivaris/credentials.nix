{
  username,
  config,
  pkgs,
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

  programs.git = {
    enable = true;
    userName = username;
    userEmail = "github@tripple.lurdane.de";
    extraConfig.credential.helper = "store";
    extraConfig.core.autocrlf = "input";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      IdentityFile ${keyPath}
    '';
  };

  programs.keychain = {
    enable = true;
    keys = [ keyPath ];
    extraFlags = [ "--quiet" ];
  };

  home.sessionVariables = {
    SSH_ASKPASS = "${askPass}/bin/ssh-askpass-${username}";
    SSH_ASKPASS_REQUIRE = "force";
    DISPLAY = ":0";
  };

  home.packages = [ askPass ];

}
