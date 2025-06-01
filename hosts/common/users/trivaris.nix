{
  host,
  config,
  inputs,
  ...
}:
{

  users.users."trivaris" = {
    hashedPasswordFile = config.sops.secrets.trivaris-password.path;
    isNormalUser = true;
    createHome = true;
    home = "/home/trivaris";
    description = "trivaris";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcDawyUNp6CxabcDaK7J1y9Vedj2ifub1OHFYHgeNq+ trivaris@TrivDesktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZ5qYNT8/jy6XlfK1QRmCbcUvSEW/WFpBVTHEckZxkF trivaris@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO69PGqoy0ypc2zMKYKU/nvrkwkg95m6bVMs+M9CFMWo root@nixos"
    ];
  };

  home-manager.users.trivaris = import (inputs.self + "/home/trivaris/${host.name}.nix");

}
  