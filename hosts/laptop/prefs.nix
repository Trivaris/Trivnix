{
  flake.nixosModules.laptop = {
    services.blueman.enable = true;
    virtualisation.docker.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandlePowerKey = "suspend";
    };

    hostPrefs = {
      mainUser = "trivaris";
      enableFingerPrintAuth = true;
      steam.enable = true;
      openssh.enable = true;
    };
  };
}
