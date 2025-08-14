{
  pkgs,
  config,
  lib,
  libExtra,
  hostInfo,
  userPrefs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
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
        nixos.expr = "(builtins.getFlake \"${selfPath}\").hostprefsurations.${hostInfo.name}.options";
        home-manager.expr = "(builtins.getFlake \"${selfPath}\").homeConfigs.\"${userPrefs.name}@${hostInfo.name}\".options";
      };
    };
  };

  vscodiumSettings = commonSettings // (if (cfg.vscodium.enableLsp) then lspSettings else { });
in
{
  options.homeConfig.vscodium = import ./config.nix { inherit (lib) mkEnableOption; };

  config = mkIf (builtins.elem "vscodium" cfg.desktopApps) (mkMerge [

    {
      home.packages = builtins.attrValues (
        {
          inherit (pkgs) vscodium;
        }

        // (
          if cfg.vscodium.enableLsp then
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
          if cfg.vscodium.fixServer then
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
