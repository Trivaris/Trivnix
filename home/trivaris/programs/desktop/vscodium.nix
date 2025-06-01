{
  pkgs,
  inputs,
  ...
}:
{

  home.packages = with pkgs; [
    vscodium
    nodejs_20
    nixd
    nixfmt-rfc-style
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
              "expr" = "(builtins.getFlake \"/home/trivaris/trivnix\").homeConfigurations.\"trivaris@trivlaptop\".options";
          };
        };
      };
    };
  };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

}
