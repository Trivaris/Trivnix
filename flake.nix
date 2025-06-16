{
  description = ''
    Trivaris' NixOS Config. Built on top of m3tam3re's series.
  '';

  # Centralize input definitions
  inputs = import ./flake/inputs.nix;

  # Delegate output logic to separate module
  outputs =
    inputs@{ self, ... }:
    import ./flake/outputs.nix {
      inherit inputs self;
    };
}
