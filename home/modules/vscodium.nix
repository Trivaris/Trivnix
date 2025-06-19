{
  inputs,
  pkgs,
  username,
  hostname,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules;
  selfPath = toString inputs.self;
in
with lib;
{

  options.homeModules.vscodium = mkEnableOption "vscodium";
  config = mkIf cfg.vscodium {
    home = {
      packages = with pkgs; [
        vscodium
        nixd
        nodejs_20
        nixfmt-rfc-style
        nix-ld
        vscode-extensions.jnoortheen.nix-ide
      ];

      file.".vscodium-server/data/Machine/settings.json".text = builtins.toJSON {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";

        "nix.serverSettings".nixd = {
          formatting.command = [ "nixfmt" ];

          nixpkgs.expr = "import (builtins.getFlake \"${selfPath}\").inputs.nixpkgs { } ";

          options = {
            nixos.expr = "(builtins.getFlake \"${selfPath}\").nixosConfigurations.${hostname}.options";
            home-manager.expr = "(builtins.getFlake \"${selfPath}\").homeConfigurations.\"${username}@${hostname}\".options";
          };
        };
      };

      activation.fixVSCodiumNode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        target="$(find ${config.home.homeDirectory}/.vscodium-server/bin -type f -name node 2>/dev/null | head -n1)"
        if [ -n "$target" ]; then
          rm -f "$target"
          ln -sf $(command -v node) "$target"
        fi
      '';
    };
  };

}
