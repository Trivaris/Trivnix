{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    home-manager
    coreutils
    httpie
    fd
    ripgrep
    tldr
    zip
    bat
    neovim
    git
    fish
    wget
    sops
    age

    r-matrix
    rbonsai
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
    allowSFTP = true;
    openFirewall = false;
    hostKeys = [ {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    } ];
  };

}
