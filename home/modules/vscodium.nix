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

  options.homeModules.vscodium.enable = mkEnableOption "vscodium";
  config = mkIf cfg.vscodium.enable {
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
        for d in ${config.home.homeDirectory}/.vscodium-server/bin/*; do
          [ -d "$d" ] || continue
          target="$d/node"
          new_node="${pkgs.nodejs_20}/bin/node"

          if [ ! -e "$target" ]; then
            echo "✔ node does not exist, creating symlink at $target"
            ln -sf "$new_node" "$target"

          elif [ -f "$target" ]; then
            echo "✔ node is a regular file, replacing with symlink at $target"
            rm -f "$target"
            ln -sf "$new_node" "$target"

          elif [ -L "$target" ]; then
            echo "✔ node is a symlink, replacing with new symlink at $target"
            rm -f "$target"
            ln -sf "$new_node" "$target"

          else
            echo "✖ node exists but is not a file or symlink: $target (skipped)"
          fi
        done
      '';

    };
  };

}
