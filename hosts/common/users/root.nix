{
  ...
}: {

  users.users."root" = {
    initialHashedPassword = "$y$j9T$F0vD5H2XbmMLxbb9X7Z5L1$vD9TLGi6l/yKBsiAIobtQuL3/md/TFIt0PdGDjyyUb7";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcDawyUNp6CxabcDaK7J1y9Vedj2ifub1OHFYHgeNq+ trivaris@TrivDesktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZ5qYNT8/jy6XlfK1QRmCbcUvSEW/WFpBVTHEckZxkF trivaris@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO69PGqoy0ypc2zMKYKU/nvrkwkg95m6bVMs+M9CFMWo root@nixos"
    ];
  };

}