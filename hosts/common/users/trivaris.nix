{
  hostname,
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  username = "trivaris";
in
{

  users.users.${username} = {
    hashedPasswordFile = "$y$j9T$e5w7wxGxa5WsOmwq1QyBo.$DwqslvRdBguctbD2KZAOgub7yjChIorXejNfWQwmV11";
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = username;
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

  home-manager.users.${username} = import (inputs.self + "/home/${username}/${hostname}.nix") {
    inherit inputs config lib pkgs username system; 
  };

}
  