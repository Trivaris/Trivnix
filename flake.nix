{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Core/community modules
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    disko.url = "github:nix-community/disko";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    # qml-language-server.url = "github:cushycush/qml-language-server";

    # Trivnix modules
    trivnixPrivate.url = "git+ssh://git@git.trivaris.org/Trivaris/TrivnixPrivate";

    hyprqt6engine.url = "github:hyprwm/hyprqt6engine";
    hyprland.url = "github:hyprwm/Hyprland";
    epic-games-launcher.url = "github:kjetteren/epic-games-launcher-flake";
    # mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.disko.flakeModules.default
        inputs.flake-parts.flakeModules.easyOverlay
        # {
        #   systems = [
        #     "x86_64-linux"
        #   ];
        # }
        (inputs.import-tree [
          ./disko
          ./hosts
          ./lib
          ./modules/home
          ./modules/nixos
          ./overlays
          ./packages
          ./shells
        ])
      ];
    };
}
