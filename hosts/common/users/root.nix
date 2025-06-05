{ inputs, config, ... }:
let
  hosts = [
    "desktop"
    "laptop"
    "wsl"
  ];
in
{

  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
    openssh.authorizedKeys.keys = map (host: builtins.readFile (inputs.self + "/resources/ssh-pub/id_ed25519_${host}.pub")) hosts;
  };

}