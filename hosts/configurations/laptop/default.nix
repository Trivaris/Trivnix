{ lib-extra, ... }:
lib-extra.mkHostConfig {

  extraImports = [ ./hardware.nix ];

  config = {
    nixosModules = {
      android-emulator = true;
      bluetooth = true;
      fish = true;
      hyprland = true;
      openssh = true;
      printing = true;
    };
  };

}
