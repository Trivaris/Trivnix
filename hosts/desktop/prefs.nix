{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.flatpak.enable = true;
      environment.systemPackages = [
        pkgs.mpv
      ];
      programs.epic-games-launcher.enable = true;

      hostPrefs = {
        mainUser = "trivaris";
        steam.enable = true;

        openssh = {
          enable = true;
          ports = [ 23232 ];
        };
      };
    };
}
