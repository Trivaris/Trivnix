{ 
  config,
  ...
}:
{

  users.users."root" = {
    hashedPasswordFile = "$y$j9T$e5w7wxGxa5WsOmwq1QyBo.$DwqslvRdBguctbD2KZAOgub7yjChIorXejNfWQwmV11";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfeJK7INUQiwhkv+k5JBg9yWzEZOJ3uLpoCZULXkmPu trivaris@trivdesktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICZc1kVtfzflynwpzbTHFoUIrHGSYJte6yoZ1CMsFke trivaris@trivlaptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfOiSGvvuk5bpc/q5g7Xkg2ORs2Grt1dYF4ZGJkVFAe trivaris@trivwsl"
    ];
  };

}
