{
  libExtra,
  config,
  username,
  stateVersion,
  ...
}:
let
  hosts = [
    "trivdesktop"
    "trivlaptop"
    "trivwsl"
    "trivserver"
  ];
in
{

  home-manager.extraSpecialArgs = { inherit username stateVersion; };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets."user-passwords/${username}".path;
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = username;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
      "Docker"
    ];
    openssh.authorizedKeys.keys = map builtins.readFile (
      builtins.concatLists (
        map (host: [
          (libExtra.mkFlakePath "/resources/ssh-pub/id_ed25519_sk_rk_${host}_a.pub")
          (libExtra.mkFlakePath "/resources/ssh-pub/id_ed25519_sk_rk_${host}_c.pub")
        ]) hosts
      )
    );
  };

}
