{ lib-extra, ... }:
lib-extra.mkHostConfig {

  extraImports = [ ./hardware.nix ];

  config = {
    nixosModules = {
      bluetooth = true;
      fish = true;
      hyprland = true;
      openssh = true;
      printing = true;
    };
  };

}
