{ inputs, system ? "x86_64-linux" }:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  makeTest = import (inputs.nixpkgs + "/nixos/tests/make-test-python.nix") { inherit pkgs; };
in
makeTest ({ pkgs, ... }:
{
  name = "openssh-module";
  nodes.machine = { pkgs, ... }:
    {
      imports = [
        ../hosts/wsl/system-packages.nix
      ];
    };
  testScript = ''
    machine.start()
    machine.wait_for_unit("sshd.service")
    machine.succeed("pgrep sshd")
  '';
})
