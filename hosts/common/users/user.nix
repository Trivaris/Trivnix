{
  lib-extra,
  config,
  username,
  stateVersion,
  ...
}:
let
  hosts = [
    "desktop"
    "laptop"
    "wsl"
    "server"
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
    openssh.authorizedKeys.keys = map (
      host: builtins.readFile (lib-extra.mkFlakePath "/resources/ssh-pub/id_ed25519_${host}.pub")
    ) hosts;
  };

}
