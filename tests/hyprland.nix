{ inputs, system ? "x86_64-linux" }:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  makeTest = import (inputs.nixpkgs + "/nixos/tests/make-test-python.nix") { inherit pkgs; };
in
makeTest ({ pkgs, ... }:
{
  name = "hyprland-module";
  nodes.machine = { pkgs, ... }:
    {
      imports = [
        ../hosts/laptop/system-packages.nix
      ];
    };
  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("command -v Hyprland")
  '';
})
