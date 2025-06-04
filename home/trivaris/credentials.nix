{ username, ... }:
{

  programs.git = {
    enable = true;
    userName = username;
    userEmail = "github@tripple.lurdane.de";
    extraConfig.credential.helper = "store";
  };

  programs.ssh = {
    enable = true;
    #startAgent = true;
    addKeysToAgent = "yes";
    #extraConfig = ''
    #  IdentityFile ${config.sops.secrets.ssh-private-key.path}
    #'';
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
  };

}
