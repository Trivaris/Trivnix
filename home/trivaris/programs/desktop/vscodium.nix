{ pkgs, ... }:
{

  home.packages = with pkgs; [
    vscodium
    nixd
    nodejs_20
    nixfmt-rfc-style
    nix-ld
    vscode-extensions.jnoortheen.nix-ide
  ];

  home.file.".vscodium-server/data/Machine/settings.json".text = builtins.toJSON {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";
    "nix.serverSettings" = {
      "nixd" = {
        "formatting" = {
          "command" = [ "nixfmt" ];
        };
        "nixpkgs" = {
          "expr" = "import (builtins.getFlake \"/home/trivaris/trivnix\").inputs.nixpkgs { } ";
        };
        "options" = {
          "nixos" = {
            "expr" = "(builtins.getFlake \"/home/trivaris/trivnix\").nixosConfigurations.trivlaptop.options";
          };
          "home-manager" = {
            "expr" =
              "(builtins.getFlake \"/home/trivaris/trivnix\").homeConfigurations.\"trivaris@trivlaptop\".options";
          };
        };
      };
    };
  };

}
