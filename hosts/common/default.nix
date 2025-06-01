{
  host,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}:
let
  users = builtins.map (user: user.name) host.users;
in
{

  imports = [
    ./users
    ./sops.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    backupFileExtension = "backup";
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = users ++ [ "root" ];
    gc.automatic = true;
    gc.dates = "daily";
    gc.options = "--delete-older-than 7d";
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

}
