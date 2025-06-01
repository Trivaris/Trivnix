{
  pkgs,
  ...
}:
{

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.KbdInteractiveAuthentication = false;
    allowSFTP = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}
