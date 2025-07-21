{ inputs }:
{
  nur = inputs.nur.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;

  additions =
    pkgs: _prev:
    {
      rmatrix = pkgs.callPackage ./pkgs/rmatrix.nix { inherit inputs pkgs; };
      rbonsai = pkgs.callPackage ./pkgs/rbonsai.nix { inherit inputs pkgs; };
      vaultwarden-web-vault = pkgs.callPackage ./pkgs/vaultwarden-web-vault.nix { inherit inputs pkgs; };
      keeweb = pkgs.callPackage ./pkgs/keeweb.nix { inherit inputs pkgs; };
      instagram-cli = pkgs.callPackage ./pkgs/instagram-cli.nix { inherit inputs pkgs; };

      elysium-days = pkgs.callPackage ./pkgs/modpacks/elysium-days.nix { inherit inputs pkgs; };
      versatile = pkgs.callPackage ./pkgs/modpacks/versatile.nix { inherit inputs pkgs; };
    };

  modifications =
    pkgs: prev:
    {
      suwayomi-server = prev.suwayomi-server.overrideAttrs (previousAttrs: 
        import ./pkgs/suwayomi-server.nix {
          inherit inputs;
          pkgs = pkgs;
          old = previousAttrs;
        }
      );
    };

  stable-packages = pkgs: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = pkgs.system;
      config.allowUnfree = true;
    };
  };

}
