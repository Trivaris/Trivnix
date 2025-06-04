{ inputs, ... }:
let
  hosts = [
    "desktop"
    "laptop"
    "wsl"
  ];
in
map (host: builtins.readFile (inputs.self + "/resources/ssh-pub/id_ed25519_${host}.pub")) hosts
