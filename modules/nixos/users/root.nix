{ inputs, config, ... }:
{

  users.users."root" = {
    hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
    openssh.authorizedKeys.keys = import ./authorized-keys.nix { inherit inputs; };
  };

}
