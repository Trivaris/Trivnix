{
  username,
  config,
  pkgs,
  configname,
  ...
}:
let
  keyPath = config.sops.secrets."ssh-private-keys/${username}/${configname}/key".path;
  passPath = config.sops.secrets."ssh-private-keys/${username}/${configname}/passphrase".path;

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
  };

  programs.ssh = {
    enable          = true;
    addKeysToAgent  = "yes";
    extraConfig     = ''
      IdentityFile ${keyPath}
    '';
  };

  programs.keychain = {
    enable     = true;
    keys       = [ keyPath ];
    extraFlags = [ "--quiet" ];
  };

  home.sessionVariables = {
    SSH_ASKPASS          = "${askPass}/bin/ssh-askpass-${username}";
    SSH_ASKPASS_REQUIRE  = "force";
    DISPLAY              = ":0";
  };

  home.packages = [ askPass ];

}
