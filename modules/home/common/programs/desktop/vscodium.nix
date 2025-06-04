{
  pkgs,
  username,
  hostname,
  ...
}:
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
          "expr" = "import (builtins.getFlake \"/home/${username}/trivnix\").inputs.nixpkgs { } ";
        };
        "options" = {
          "nixos" = {
            "expr" =
              "(builtins.getFlake \"/home/${username}/trivnix\").nixosConfigurations.${hostname}.options";
          };
          "home-manager" = {
            "expr" =
              "(builtins.getFlake \"/home/${username}/trivnix\").homeConfigurations.\"${username}@${hostname}\".options";
          };
        };
      };
    };
  };

}
