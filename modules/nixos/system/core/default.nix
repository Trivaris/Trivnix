{
  flake.nixosModules.system-core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        time.timeZone = "Europe/Berlin";
        programs.nix-ld.enable = true;

        nix = {
          package = lib.mkDefault pkgs.nix;
          optimise.automatic = true;

          gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than ${config.host-prefs.oldProfileDeleteInterval}";
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
