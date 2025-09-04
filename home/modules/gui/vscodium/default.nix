{
  pkgs,
  config,
  lib,
  trivnixLib,
  hostInfos,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  prefs = config.userPrefs;
  selfPath = trivnixLib.mkStorePath "";

  commonSettings = {
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "explorer.confirmDelete" = false;
    "svelte.enable-ts-plugin" = true;
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

  vscodiumSettings = commonSettings // (if (prefs.vscodium.enableLsp) then lspSettings else { });
in
{
  options.userPrefs.vscodium = import ./config.nix { inherit (lib) mkEnableOption; };

  config = mkIf (builtins.elem "vscodium" prefs.gui) (mkMerge [

    {
      home.packages = builtins.attrValues (
        {
          inherit (pkgs) vscodium;
        }

        // (
          if prefs.vscodium.enableLsp then
            {
              inherit (pkgs.vscode-extensions.jnoortheen) nix-ide;

              inherit (pkgs)
                nixd
                nixfmt-rfc-style
                nix-ld
                ;
            }
          else
            { }
        )

        // (
          if prefs.vscodium.fixServer then
            {
              inherit (pkgs) nodejs_20;
            }
          else
            { }
        )
      );
    }

    {
      home.file.".vscodium-server/data/Machine/settings.json".text = builtins.toJSON vscodiumSettings;
      home.file.".config/VSCodium/User/settings.json".text = builtins.toJSON vscodiumSettings;
    }

    (mkIf prefs.vscodium.fixServer {
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
