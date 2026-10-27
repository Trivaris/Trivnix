#!/usr/bin/env bash
set -euo pipefail

output=${1:-"README.md"}
flake_uri="github:trivaris/trivnixconfigs"

mkdir -p "$(dirname "$output")"

nix_expr=$(cat <<'EOF'
let
  configFlake = builtins.getFlake "FLAKE_URI_PLACEHOLDER";
  nixpkgs = configFlake.inputs.nixpkgs;
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  lib = nixpkgs.lib;

  # Extract the option tree from a known host. 
  # This only reads the definitions (mkOption) and ignores specific config values.
  configuration = configFlake.nixosConfigurations.desktop;

  publicNamespaces = [ "hostPrefs" "userPrefs" "vars" ];
  filterPublic = lib.filterAttrs (name: _: builtins.elem name publicNamespaces);

  hostOptions = filterPublic configuration.options;
  homeOptions = filterPublic (configuration.options.home-manager.users.type.getSubOptions [ ]);

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

Generated standalone reference from \`FLAKE_URI_PLACEHOLDER\`.

This reference covers the public Trivnix namespaces: \`hostPrefs\`, \`userPrefs\`, and derived \`vars\` values. It intentionally excludes standard NixOS options.

## NixOS and host options
INNER_EOF

    nixos-render-docs options markdown \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      ${hostDoc.optionsJSON}/share/doc/nixos/options.json \
      >> $out/README.md
      
    echo -e "\n## Home Manager options\n" >> $out/README.md
    
    nixos-render-docs options markdown \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      ${homeDoc.optionsJSON}/share/doc/nixos/options.json \
      >> $out/README.md
  '';
}
EOF
)

nix_expr="${nix_expr//FLAKE_URI_PLACEHOLDER/$flake_uri}"

store_path=$(nix build --impure --no-link --print-out-paths --expr "$nix_expr")

cp "$store_path/README.md" "$output"
chmod +w "$output"

printf 'Generated pure options reference at %s.\n' "$output"