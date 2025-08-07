inputs:
let
  mkModpack = import ./mkModpack.nix;
in
{
  nur = inputs.nur.overlays.default;
  minecraft = inputs.nix-minecraft.overlay;
  millennium = inputs.millennium.overlays.default;

  additions = final: pkgs: {
    rmatrix = pkgs.callPackage ./pkgs/rmatrix.nix pkgs;
    rbonsai = pkgs.callPackage ./pkgs/rbonsai.nix pkgs;
    vaultwarden-web-vault = pkgs.callPackage ./pkgs/vaultwarden-web-vault.nix pkgs;
    keeweb = pkgs.callPackage ./pkgs/keeweb.nix pkgs;
    instagram-cli = pkgs.callPackage ./pkgs/instagram-cli.nix pkgs;
    adbautoplayer = pkgs.callPackage ./pkgs/adbautoplayer.nix pkgs;

    modpacks = {
      elysium-days = pkgs.callPackage mkModpack {
        inherit pkgs;
        modrinthUrl = "https://cdn.modrinth.com/data/lz3ryGPQ/versions/azCePsLz/Elysium%20Days%207.0.0.mrpack";
        hash = "sha256-/1xIPjUSV+9uPU8wBOr5hJ3rHb2V8RkdSdhzLr/ZJ2Y=";
      };

      rising-legends = pkgs.callPackage mkModpack {
        inherit pkgs;
        modrinthUrl = "https://cdn.modrinth.com/data/Qx4KOI2G/versions/SVpfGIfp/Rising%20Legends%202.2.0.mrpack";
        hash = "sha256-kCMJ6PUSaVr5Tpa9gFbBOE80kUQ4BaNLE1ZVzTfqTFM=";
      };
    };
  };

  modifications = final: pkgs: {
    suwayomi-server = pkgs.suwayomi-server.overrideAttrs (
      oldAttrs: import ./overrides/suwayomi-server.nix pkgs
    );
  };

  stable-packages = final: pkgs: {
    stable = import inputs.nixpkgs-stable {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
  };
}
