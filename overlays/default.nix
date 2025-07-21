{ inputs }:
{
  nur = inputs.nur.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;

  additions =
    final: _prev:
    {
      rmatrix = final.callPackage ./pkgs/rmatrix.nix { inherit inputs; pkgs = final; };
      rbonsai = final.callPackage ./pkgs/rbonsai.nix { inherit inputs; pkgs = final; };
      vaultwarden-web-vault = final.callPackage ./pkgs/vaultwarden-web-vault.nix { inherit inputs; pkgs = final; };
      keeweb = final.callPackage ./pkgs/keeweb.nix { inherit inputs; pkgs = final; };
      instagram-cli = final.callPackage ./pkgs/instagram-cli.nix { inherit inputs; pkgs = final; };

      elysium-days = final.callPackage ./pkgs/modpacks/elysium-days.nix { inherit inputs; pkgs = final; };
    };

  modifications =
    final: prev:
    {
      suwayomi-server = prev.suwayomi-server.overrideAttrs (previousAttrs: 
        import ./pkgs/suwayomi-server.nix {
          inherit inputs;
          pkgs = final;
          old = previousAttrs;
        }
      );
    };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
