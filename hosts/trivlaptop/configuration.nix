{ ... }:
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "trivlaptop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "25.05";

}
