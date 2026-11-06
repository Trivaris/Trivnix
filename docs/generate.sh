#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
flake_uri="git+file://$repo_root?shallow=1"

output=${1:-"$repo_root/docs/index.md"}

mkdir -p "$(dirname "$output")"

nix_expr=$(cat <<'EOF'
let
  trivnix = builtins.getFlake "FLAKE_URI_PLACEHOLDER";

  eval = trivnix.nixosConfigurations.desktop;
  pkgs = eval.pkgs;
  lib = pkgs.lib;

  publicNamespaces = [ "hostPrefs" "userPrefs" "vars" "themingPrefs" ];
  
  filterPublic = lib.filterAttrs (name: _: builtins.elem name publicNamespaces);

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
    
    cat > $out/README.md <<'INNER_EOF'
# Trivnix Option Reference

Read more about this Repo:
- [Getting started](./getting-started.md)
- [Development](./development.md)
- [Architecture](./architecture.md)
- [Modules](./modules.md)
- [Private Integration](./private-integration.md)

Generated standalone reference from the local trivnix module tree.

This reference covers the public Trivnix namespaces: `hostPrefs`, `userPrefs`, `themingPref` and derived `vars` values.

## NixOS and host options
INNER_EOF

    nixos-render-docs options commonmark \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      --revision "main" \
      ${hostDoc.optionsJSON}/share/doc/nixos/options.json \
      $out/host_rendered.md
      
    cat $out/host_rendered.md >>$out/README.md

    echo -e "\n## Home Manager options\n" >> $out/README.md
    
    nixos-render-docs options commonmark \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      --revision "main" \
      ${homeDoc.optionsJSON}/share/doc/nixos/options.json \
      $out/home_rendered.md

    cat $out/home_rendered.md >>$out/README.md
  '';
}
EOF
)

nix_expr="${nix_expr//FLAKE_URI_PLACEHOLDER/$flake_uri}"

store_path=$(nix build --impure --no-link --print-out-paths --expr "$nix_expr" --refresh)

cp "$store_path/README.md" "$output"
chmod +w "$output"

printf 'Generated pure options reference at %s\n' "$output"
