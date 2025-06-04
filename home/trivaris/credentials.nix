{
  username,
  config,
  configname,
  ...
}:
{

  programs.git = {
    enable = true;
    userName = username;
    userEmail = "github@tripple.lurdane.de";
    extraConfig.credential.helper = "store";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      IdentityFile ${config.sops.secrets."ssh-private-keys/${configname}".path}
    '';
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
  };

}
