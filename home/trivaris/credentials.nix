{ ... }:
{

  programs.git = {
    enable = true;
    userName = "trivaris";
    userEmail = "github@tripple.lurdane.de";
    extraConfig.credential.helper = "store";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    #extraConfig = ''
    #  IdentityFile ${config.sops.secrets.ssh-private-key.path}
    #'';
  };

}
