{ ... }:
{

  users.users."root" = {
    hashedPassword = "$y$j9T$e5w7wxGxa5WsOmwq1QyBo.$DwqslvRdBguctbD2KZAOgub7yjChIorXejNfWQwmV11";
    openssh.authorizedKeys.keys = import ./authorized-keys.nix;
  };

}
