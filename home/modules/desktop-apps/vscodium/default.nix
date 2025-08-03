{
  pkgs,
  config,
  lib,
  libExtra,
  hostconfig,
  userconfig,
  ...
}:
with lib;
let
  cfg = config.homeConfig;
  selfPath = libExtra.mkFlakePath "/" ;
  
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
  options.homeConfig.vscodium = import ./config.nix lib;

  config = mkIf (builtins.elem "vscodium" cfg.desktopApps) (mkMerge [
    {
      home.packages = with pkgs; [
        vscodium
      ]

      ++ (optionals cfg.vscodium.enableLsp [
        nixd
        nixfmt-rfc-style
        nix-ld
        vscode-extensions.jnoortheen.nix-ide
      ])

      ++ (optionals cfg.vscodium.fixServer [
        nodejs_20
      ]); 
    }

    {
      home.file.".vscodium-server/data/Machine/settings.json".text = builtins.toJSON ( mkMerge [ 
        commonSettings
        (mkIf (cfg.vscodium.enableLsp) lspSettings)
      ]);

      home.file.".config/VSCodium/User/settings.json".text = builtins.toJSON ( mkMerge [ 
        commonSettings
        (mkIf (cfg.vscodium.enableLsp) lspSettings)
      ]);
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