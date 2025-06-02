{
  inputs,
  ...
}:
{

  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {

  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
