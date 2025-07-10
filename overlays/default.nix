{ inputs }:
{
  nur = inputs.nur.overlays.default;

  additions =
    final: _prev:
    import ./additions {
      inherit inputs;
      pkgs = final;
    };

  modifications =
    final: prev:
    import ./modifications {
      inherit inputs;
      pkgs = prev;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
