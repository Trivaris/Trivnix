{
  pkgs,
  config,
  lib,
  libExtra,
  hostconfig,
  userconfig,
  ...
}:
let
  inherit (lib) mkIf mkMerge optionals;
  cfg = config.homeConfig;
  selfPath = libExtra.mkFlakePath "/";

  commonSettings = {
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
  };

  lspSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";

    "nix.serverSettings".nixd = {
      formatting.command = [ "nixfmt" ];

      nixpkgs.expr = "import (builtins.getFlake \"${selfPath}\").inputs.nixpkgs { } ";

      options = {
        nixos.expr = "(builtins.getFlake \"${selfPath}\").nixosConfigurations.${hostconfig.name}.options";
        home-manager.expr = "(builtins.getFlake \"${selfPath}\").homeConfigurations.\"${userconfig.name}@${hostconfig.name}\".options";
      };
    };
  };
in
{
  options.homeConfig.vscodium = import ./config.nix { inherit (lib) mkEnableOption; };

  config = mkIf (builtins.elem "vscodium" cfg.desktopApps) (mkMerge [
    {
      home.packages =
        builtins.attrValues {
          inherit (pkgs)
            vscodium
            ;
        }
        // (optionals (cfg.vscodium.enableLsp) builtins.attrValues {
          inherit (pkgs)
            nixd
            nixfmt-rfc-style
            nix-ld
            ;
          inherit (pkgs.vscode-extensions.jnoortheen)
            nix-ide
            ;
        })

        // (optionals (cfg.vscodium.fixServer) builtins.attrValues {
          inherit (pkgs)
            nodejs_20
            ;
        });
    }

    {
      home.file.".vscodium-server/data/Machine/settings.json".text = builtins.toJSON (
        commonSettings // (if (cfg.vscodium.enableLsp) then lspSettings else { })
      );

      home.file.".config/VSCodium/User/settings.json".text = builtins.toJSON (
        commonSettings // (if (cfg.vscodium.enableLsp) then lspSettings else { })
      );
    }

    (mkIf cfg.vscodium.fixServer {
      home.activation.fixVSCodiumServer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
    })
  ]);
}
