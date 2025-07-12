{ inputs }:
{
  nur = inputs.nur.overlays.default;

  additions =
    final: _prev:
    {
      rmatrix = final.callPackage ./pkgs/rmatrix.nix { inherit inputs; pkgs = final; };
      rbonsai = final.callPackage ./pkgs/rbonsai.nix { inherit inputs; pkgs = final; };
    };

  modifications =
    final: prev:
    {
      suwayomi-server = prev.suwayomi-server.overrideAttrs (previousAttrs: 
        import ./pkgs/suwayomi-server { inherit inputs; pkgs = final; }
      );
    };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
