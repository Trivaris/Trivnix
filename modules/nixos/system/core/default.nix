{
  flake.nixosModules.system-core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      themePrefs = config.themingPrefs;
      allUserPrefs = builtins.attrValues (
        builtins.mapAttrs (_: cfg: cfg.userPrefs) config.home-manager.users
      );
    in
    {
      config = {
        time.timeZone = "Europe/Berlin";
        programs.nix-ld.enable = true;
        environment.systemPackages = [ pkgs.home-manager ];
        qt.enable = true;

        networking = {
          networkmanager.plugins = [ pkgs.networkmanager-strongswan ];
          firewall.allowedTCPPorts = lib.mkIf (lib.any (prefs: prefs.wayvnc.enable or false) allUserPrefs) [
            5900
          ];
        };

        fonts = {
          enableDefaultPackages = true;
          packages = [ themePrefs.font.package ] ++ themePrefs.font.extraFonts;
          fontconfig = {
            enable = true;
            useEmbeddedBitmaps = true;
            defaultFonts = {
              emoji = [ "Noto Color Emoji" ];
              monospace = [ themePrefs.font.monoName ];
              sansSerif = [ themePrefs.font.propoName ];
              serif = [ themePrefs.font.propoName ];
            };
          };
        };

        nix = {
          package = lib.mkDefault pkgs.nix;
          optimise.automatic = true;

          gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than ${config.hostPrefs.oldProfileDeleteInterval}";
          };

          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
            auto-optimise-store = true;
            substituters = [ "https://hyprland.cachix.org" ];
            trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
          };
        };
      };
    };
}
