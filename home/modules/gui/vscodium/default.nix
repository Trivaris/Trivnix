{
  config,
  lib,
  pkgs,
  hostInfos,
  trivnixLib,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf mkMerge hm;

  prefs = config.userPrefs;
  selfPath = trivnixLib.mkStorePath "";
  vscodiumSettings = commonSettings // (if prefs.vscodium.enableLsp then lspSettings else { });

  commonSettings = {
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "explorer.confirmDelete" = false;
    "svelte.enable-ts-plugin" = true;
    "explorer.confirmDragAndDrop" = false;
  };

  lspSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";

    "nix.serverSettings".nixd = {
      formatting.command = [ "nixfmt" ];

      nixpkgs.expr = "import (builtins.getFlake \"${selfPath}\").inputs.nixpkgs { } ";

      options = {
        nixos.expr = "(builtins.getFlake \"${selfPath}\").nixosConfigurations.${hostInfos.name}.options";
        home-manager.expr = "(builtins.getFlake \"${selfPath}\").homeConfigurations.\"${userInfos.name}@${hostInfos.name}\".options";
      };
    };
  };
in
{
  options.userPrefs.vscodium = import ./options.nix { inherit (lib) mkEnableOption; };

  config = mkIf (builtins.elem "vscodium" prefs.gui) (mkMerge [
    { home.packages = [ pkgs.vscodium ]; }
    (mkIf prefs.vscodium.fixServer { home.packages = [ pkgs.nodejs_20 ]; })
    (mkIf prefs.vscodium.enableLsp {
      home.packages = builtins.attrValues {
        inherit (pkgs.vscode-extensions.jnoortheen) nix-ide;
        inherit (pkgs)
          nixd
          nixfmt-rfc-style
          nix-ld
          ;
      };
    })

    {
      home.file = {
        ".vscodium-server/data/Machine/settings.json".text = builtins.toJSON vscodiumSettings;
        ".config/VSCodium/User/settings.json".text = builtins.toJSON vscodiumSettings;
      };
    }

    (mkIf prefs.vscodium.fixServer {
      home.activation.fixVSCodiumServer = hm.dag.entryAfter [ "writeBoundary" ] ''
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
