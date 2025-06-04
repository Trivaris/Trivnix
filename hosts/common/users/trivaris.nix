{pkgs, configname, inputs, ... }:
let
  username = "trivaris";
in
{

  home-manager.users.${username} = { ... }: {
     _module.args.username = username;
    imports = [
      "${inputs.self}/home/${username}/${configname}.nix"
    ];
  };

  users.users.${username} = {
    hashedPassword = "$y$j9T$e5w7wxGxa5WsOmwq1QyBo.$DwqslvRdBguctbD2KZAOgub7yjChIorXejNfWQwmV11";
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = username;
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
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
    ];
    openssh.authorizedKeys.keys = import ./authorized-keys.nix;
  };


}
  