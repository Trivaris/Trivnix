{
  config,
  pkgs,
  inputs,
  ...
}: {

  users.users.trivaris = {
    initialHashedPassword = "$y$j9T$F0vD5H2XbmMLxbb9X7Z5L1$vD9TLGi6l/yKBsiAIobtQuL3/md/TFIt0PdGDjyyUb7";
    isNormalUser = true;
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
    ];

  };
  home-manager.users.trivaris =
    import ../../../home/trivaris;

}