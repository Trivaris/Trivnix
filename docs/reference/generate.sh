#!/usr/bin/env bash
set -euo pipefail

# Dynamically resolve the absolute path to the repo root
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
flake_uri="git+file://$repo_root"

# Default output target is README.md located in the repo root
output=${1:-"$repo_root/docs/reference/README.md"}

mkdir -p "$(dirname "$output")"

nix_expr=$(cat <<'EOF'
let
  trivnix = builtins.getFlake "FLAKE_URI_PLACEHOLDER";
  
  # Fetch standard libraries
  nixpkgs = builtins.getFlake "github:NixOS/nixpkgs/nixos-unstable";
  hmFlake = builtins.getFlake "github:nix-community/home-manager";
  
  # Fetch your custom library
  trivnixLib = builtins.getFlake "git+ssh://git@git.trivaris.org/Trivaris/TrivnixLib";
  
  # Apply the trivnixLib overlay so pkgs.lib gets your custom functions
  pkgs = import nixpkgs { 
    system = "x86_64-linux";
    overlays = [ trivnixLib.overlays.default ];
  };
  
  # customLib contains mkReverseProxyOption
  customLib = pkgs.lib;
  
  # baseLib contains the nixosSystem scaffolding function
  baseLib = nixpkgs.lib;

  # Spin up a blank-slate dummy system using the base flake library
  eval = baseLib.nixosSystem {
    system = "x86_64-linux";
    # Inject the extended customLib into the inner evaluation environment
    specialArgs = { lib = customLib; };
    modules = [
      hmFlake.nixosModules.home-manager
      trivnixLib.nixosModules.default
      trivnix.nixosModules.default
      {
        # Load home modules exactly as trivnixconfigs does
        home-manager.sharedModules = [ trivnix.homeModules.default ];
      }
      # Stop Nix from validating config blocks for missing external flakes
      { _module.check = false; }
    ];
  };

  publicNamespaces = [ "hostPrefs" "userPrefs" "vars" ];
  filterPublic = customLib.filterAttrs (name: _: builtins.elem name publicNamespaces);

  hostOptions = filterPublic eval.options;
  homeOptions = filterPublic (eval.options.home-manager.users.type.getSubOptions [ ]);

  cleanOpt = opt: opt // { declarations = []; };

  hostDoc = pkgs.nixosOptionsDoc {
    options = hostOptions;
    transformOptions = cleanOpt;
  };
  
  homeDoc = pkgs.nixosOptionsDoc {
    options = homeOptions;
    transformOptions = cleanOpt;
  };

in
pkgs.stdenv.mkDerivation {
  name = "trivnix-docs";
  buildInputs = [ pkgs.nixos-render-docs ];
  buildCommand = ''
    mkdir -p $out
    
    cat > $out/README.md <<INNER_EOF
# Trivnix Option Reference

Generated standalone reference from the local trivnix module tree.

This reference covers the public Trivnix namespaces: \`hostPrefs\`, \`userPrefs\`, and derived \`vars\` values.

## NixOS and host options
INNER_EOF

    nixos-render-docs options commonmark \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      --revision "main" \
      ${hostDoc.optionsJSON}/share/doc/nixos/options.json \
      $out/host_rendered.md
      
    cat $out/host_rendered.md >> $out/README.md

    echo -e "\n## Home Manager options\n" >> $out/README.md
    
    nixos-render-docs options commonmark \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      --revision "main" \
      ${homeDoc.optionsJSON}/share/doc/nixos/options.json \
      $out/home_rendered.md

    cat $out/home_rendered.md >> $out/README.md
  '';
}
EOF
)

nix_expr="${nix_expr//FLAKE_URI_PLACEHOLDER/$flake_uri}"

store_path=$(nix build --impure --no-link --print-out-paths --expr "$nix_expr" --refresh)

cp "$store_path/README.md" "$output"
chmod +w "$output"

printf 'Generated pure options reference at %s.\n' "$output"
