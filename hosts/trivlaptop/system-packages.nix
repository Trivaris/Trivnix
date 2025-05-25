{
  pkgs,
  ...
}:{

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    allowSFTP = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}